import '@hotwired/turbo-rails';
import { start } from '@nerdgeschoss/shimmer';
import { application } from 'controllers/application';
import './controllers';

start({ application });
