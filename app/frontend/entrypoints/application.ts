import { Layout } from '../layout';
import { Reaction } from '../sprinkles/reaction';
import '../components/reset.scss';

const reaction = new Reaction({ layout: Layout });
reaction.start();
