import '@hotwired/turbo-rails';
import { start, registerServiceWorker } from '@nerdgeschoss/shimmer';
import { application } from 'controllers/application';
import './controllers';
import 'chartkick/chart.js';

start({ application });

registerServiceWorker();
