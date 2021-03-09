// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import { Socket } from "phoenix"
import topbar from "topbar"
import { LiveSocket } from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

let Hooks = {};

Hooks.PushEvent = {
    mounted() {
        window.pushEventHook = this
    }
}

Hooks.chart = {
    mounted() {
        var ctx = this.el.getContext('2d');

        var data = {
            datasets: [{
                data: [0, 0, 0],
                backgroundColor: [
                    '#E289F2',
                    '#503795',
                    '#855CF8'
                ],
            }],

            // These labels appear in the legend and in the tooltips when hovering different arcs
            labels: [
                'A-I',
                'J-R',
                'S-Z'
            ]
        };

        var chart = new Chart(ctx, {
            type: 'pie',
            data: data,
            options: {
                legend: {
                    display: true,
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                      }
                }

            }
        });

        this.handleEvent("points", ({ points }) => {
            chart.data.datasets[0].data = points
            chart.update()
        })
    }
}

let liveSocket = new LiveSocket("/live", Socket, {
    params: { _csrf_token: csrfToken },
    dom: {
        onBeforeElUpdated(from, to) {
            if (from.__x) {
                window.Alpine.clone(from.__x, to);
            }
        },
    },
    hooks: Hooks
}
)

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

