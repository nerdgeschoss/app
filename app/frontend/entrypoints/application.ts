import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';
import '../components/reset.scss';

const application = Application.start();
registerControllers(
  application,
  import.meta.glob('../controllers/**/*_controller.{ts,tsx}', { eager: true })
);
