import '@hotwired/turbo';
import { Application } from '@hotwired/stimulus';
import SidebarController from '../../components/sidebar/sidebar_controller';

const application = Application.start();
application.register('sidebar', SidebarController);

import '../components/reset.scss';
import '../../components/stack/stack.scss';
import '../../components/logo/logo.scss';
import '../../components/container/container.scss';
import '../../components/card/card.scss';
import '../../components/text/text.scss';
import '../../components/form_error/form_error.scss';
import '../../components/text_field/text_field.scss';
import '../../components/button/button.scss';
import '../../components/icon/icon.scss';
import '../../components/avatar/avatar.scss';
import '../../components/tooltip/tooltip.scss';
import '../../components/sidebar/sidebar.scss';
import '../../components/layout/layout.scss';
import '../../components/property/property.scss';
import '../../components/pill/pill.scss';
