import React from 'react';
import { renderToString } from 'react-dom/server';
// import App from '#{path.delete_suffix(".tsx")}';
// const props = #{assigns.except("ui").as_json.deep_transform_keys { |key| key.camelize(:lower) }.to_json};
// await Bun.write("#{result.path}", renderToString(<App {...props} />));

const cache = {};

const server = Bun.serve({
  port: 4000,
  async fetch(request: Request) {
    const body = await request.json();
    const path = body.path;
    const id = body.id;
    let module = cache[path];
    if (!module) {
      module = await import(path);
      cache[path] = module;
    }
    const App = module.default;
    console.log('rendering', id, body.props);
    const content = renderToString(<App {...body.props} />);
    const page = `
      <div
        data-controller="hydrate"
        data-component="${id}"
        data-props='${JSON.stringify(body.props)}'
      >
        ${content}
      </div>
    `;
    return new Response(page);
  },
});
