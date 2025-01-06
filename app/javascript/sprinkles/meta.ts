export class Meta {
  path: string;
  component: string;
  props: Record<string, unknown>;

  constructor({
    component,
    path,
    props,
  }: {
    component: Meta['component'];
    path: Meta['path'];
    props: Meta['props'];
  }) {
    this.component = component;
    this.props = props;
    this.path = path;
  }
}
