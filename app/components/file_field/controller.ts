import { Controller } from '@hotwired/stimulus';

export default class extends Controller<HTMLElement> {
  static targets = ['input', 'files', 'template'];
  declare inputTarget: HTMLInputElement;
  declare filesTarget: HTMLElement;
  declare templateTarget: HTMLTemplateElement;

  list(): void {
    const rows = this.selectedFiles().map((file, index) => {
      const row = this.templateTarget.content.cloneNode(
        true
      ) as DocumentFragment;
      row.querySelector('.file-field__name')?.append(file.name);
      row
        .querySelector<HTMLElement>('.file-field__remove')
        ?.setAttribute('data-file-field-index-param', String(index));
      return row;
    });
    this.filesTarget.replaceChildren(...rows);
  }

  remove({ params }: { params: { index: number } }): void {
    const transfer = new DataTransfer();
    this.selectedFiles()
      .filter((_file, index) => index !== params.index)
      .forEach((file) => transfer.items.add(file));
    this.inputTarget.files = transfer.files;
    this.list();
  }

  private selectedFiles(): File[] {
    return Array.from(this.inputTarget.files ?? []);
  }
}
