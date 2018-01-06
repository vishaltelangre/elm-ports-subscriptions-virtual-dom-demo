import './main.css';
import { Main } from './Main.elm';

const app = Main.embed(document.getElementById('root'));

app.ports.request.subscribe(() => {
  app.ports.receive.send({
    innerWidth: window.innerWidth,
    innerHeight: window.innerHeight,
    totalWidth: window.screen.width,
    totalHeight: window.screen.height
  });
});
