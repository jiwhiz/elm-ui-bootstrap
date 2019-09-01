import { Elm } from './Main.elm';


const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    height: window.innerHeight,
    width: window.innerWidth
  }
});

app.ports.changedUrl.subscribe(function () {
  setTimeout(function () {
    document.querySelectorAll('pre code').forEach((block) => {
      hljs.highlightBlock(block);
    });
  }, 0)
});
