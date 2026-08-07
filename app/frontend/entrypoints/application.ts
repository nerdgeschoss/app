import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';
import '../components/reset.scss';

// Phlex component styles are colocated in app/components and loaded globally.
import.meta.glob('../../components/**/*.scss', { eager: true });

const application = Application.start();
registerControllers(application, {
  ...import.meta.glob('../controllers/**/*_controller.{ts,tsx}', {
    eager: true,
  }),
  ...import.meta.glob('../../components/**/controller.{ts,tsx}', {
    eager: true,
  }),
});
