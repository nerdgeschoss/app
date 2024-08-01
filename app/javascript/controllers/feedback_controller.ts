import { Controller } from '@hotwired/stimulus';

export default class FeedbackController extends Controller {
  static targets = ['content', 'form'];

  declare readonly contentTarget: HTMLDivElement;
  declare readonly formTarget: HTMLDivElement;

  toggle(): void {
    this.contentTarget.classList.toggle('feedback__content--hidden');
    this.formTarget.classList.toggle('feedback__form--hidden');
  }
}
