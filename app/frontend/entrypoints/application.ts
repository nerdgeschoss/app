import { Layout } from '../layout';
import { Reaction } from '../sprinkles/reaction';
import '../components/reset.scss';
import '../../components/stack/stack.scss';
import '../../components/logo/logo.scss';
import '../../components/card/card.scss';
import '../../components/text/text.scss';

const reaction = new Reaction({ layout: Layout });
reaction.start();
