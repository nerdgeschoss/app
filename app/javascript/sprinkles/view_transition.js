addEventListener('turbo:before-render', (event) => {
  if (document.startViewTransition) {
    const originalRender = event.detail.render;
    event.detail.render = (currentElement, newElement) => {
      const isErrorPage = !!newElement.querySelector('#console');
      if (isErrorPage) return originalRender(currentElement, newElement);

      document.startViewTransition(() =>
        originalRender(currentElement, newElement)
      );
    };
  }
});
