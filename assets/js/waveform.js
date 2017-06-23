import { debounce } from 'lodash/function'

let siriwave

window.onresize = debounce(generateSiriWave, 250)
generateSiriWave()

function generateSiriWave() {
  const $siri_ios9 = document.getElementById('hero-waveform')

  if ($siri_ios9) {
    if (siriwave) {
      siriwave.destroy();
    }

    siriwave = new SiriWave9({
      width: $siri_ios9.clientWidth,
      height: $siri_ios9.clientHeight,
      speed: 1,
      amplitude: 0.8,
      container: $siri_ios9,
      autostart: true,
      cover: true,
      speedInterpolationSpeed: 0.01,
      amplitudeInterpolationSpeed: 0.01
    })
  }
}
