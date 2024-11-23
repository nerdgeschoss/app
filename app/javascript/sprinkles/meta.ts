export class Meta {
  component: string;
  props: any;

  constructor(data: any) {
    this.component = data.component;
    this.props = data.props;
  }
}
