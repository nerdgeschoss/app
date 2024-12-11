export class Meta {
  path: string;
  component: string;
  props: any;

  constructor({
    component,
    path,
    props,
  }: {
    component: string;
    path: string;
    props: any;
  }) {
    this.component = component;
    this.props = props;
    this.path = path;
  }
}
