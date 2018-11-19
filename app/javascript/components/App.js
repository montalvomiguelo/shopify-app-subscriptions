import React, {Component} from 'react';
import * as PropTypes from 'prop-types';
import {Redirect} from '@shopify/app-bridge/actions';
import {
  Page,
} from '@shopify/polaris';

class App extends Component {
  // This line is very important! It tells React to attach the `polaris`
  // object to `this.context` within your component.
  static contextTypes = {
    polaris: PropTypes.object,
  };

  redirectToSettings() {
    const redirect = Redirect.create(this.context.polaris.appBridge);

    // Go to {appOrigin}/settings
    redirect.dispatch(Redirect.Action.APP, '/settings');
  }

  render() {
    return (
      <Page
        breadcrumbs={[{content: 'Products', url: '/products'}]}
        title="Jar With Lock-Lid"
        primaryAction={{content: 'Save', disabled: true}}
        secondaryActions={[{content: 'Duplicate'}, {content: 'View on your store'}]}
        pagination={{
          hasPrevious: true,
          hasNext: true,
        }}
      >
        <p>Page content</p>
      </Page>
    );
  }
}

export default App;
