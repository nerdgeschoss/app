import '@hotwired/turbo-rails';
import { start, registerServiceWorker } from '@nerdgeschoss/shimmer';
import { application } from 'controllers/application';
import './controllers';

start({ application });

registerServiceWorker();
