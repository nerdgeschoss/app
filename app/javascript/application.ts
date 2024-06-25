import '@hotwired/turbo-rails';
import { start } from '@nerdgeschoss/shimmer';
import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';
import 'chartkick/chart.js';

const application = Application.start();
const controllers = import.meta.glob('../controllers/**/*_controller.ts', {
  eager: true,
});
registerControllers(application, controllers);

start({ application });
