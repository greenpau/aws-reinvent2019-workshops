# Build an AI-powered mobile app with AWS Amplify 

MOB302 for re:Invent 2019

Building an AI Powered Web Application with AWS Amplify

## Instructions

To complete this workshop, visit the instructions available at https://mob302.learn-the-cloud.com/

# MOB302 - Building an AI Powered Web Application with AWS Amplify

Add environment variables:

```bash
export AWS_DEFAULT_REGION=us-west-2
export AWS_ACCESS_KEY_ID=ASIAQSJNJRGXXLOPIOHV
export AWS_SECRET_ACCESS_KEY=nU9ZdoBN2R5+GSDKnlowO5cKFaPrToUyoo3Ph2rb
export AWS_SESSION_TOKEN=FwoGZXIvYXdzEBMaDIEDtn/rJtztCSoMUyKuAbkCRSDYEghHIBgzY1plmBsE+OuKOvXYDYzwf/lZpUstzhba1spWtK4g5QQMpPdWF7FbW8GLfngbpr/AIIm8yqv2TwcamLZNuMc259Y2igBylrzBU91Q/Ki7OupVZm2EYFTNtwSShQZ3rgyI4s4NZXCFO4am6BAj3LqzaDnDZaF1r4PaD1KkipJ+QKobWxM08Isn8z8Toj205lTCBRiOfEJjcrdwJcWe3JQNnzwgSCiN3Z/vBTItqaNmpmoOGPMLET1ahWo7xBKnJ3F69X6YDUykwds/4kmeuvh6xxEb/DL1ri3k
```

Install prerequisites:

```bash
# Update pip
sudo pip install --upgrade pip
# Update NPM
npm install -g npm
# Update the AWS CLI
pip install --user --upgrade awscli
# Install the AWS Amplify CLI
npm install -g @aws-amplify/cli
# Install create-react-app
npm -g i create-react-app
```

Add `~/.aws/config`:

```bash
# Set Region Variable
region=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')
# create default config file
cat <<END > ~/.aws/config
[default]
region=${region}
END
```

## Create the React Application

The React application will include the following components:

* `App.js` – the single page application
* `components\menu.jsx` – displays a tabbed menu for Andy’s Pizza and Sub Shop
* `components\header.jsx` – displays a header with actionable events
* `components\orders.jsx` – displays order history
* `components\sideCard.jsx` – displays the current shopping cart and recommended items

Run the following command to create the React application:

```bash
# Create the initial app
npx create-react-app andy-pizza-shop
```

Run the following commands to install the required libraries for our project:

```bash
# Change to the root directory for the application
cd andy-pizza-shop
# Install Amplify
npm i aws-amplify
# Install Amplify React
npm i aws-amplify-react
# Install React-Bootstrap
npm i bootstrap
npm i react-bootstrap
npm i reactstrap
```

To ensure the newly created application works in our environment, run the following:

```bash
# Run npm start
npm start
```

### Create the application stub

In the new terminal, run the following commands:

```bash
# Change to app directory
cd ~/environment/andy-pizza-shop
# Create components folder
mkdir src/components
# Create new component files
touch src/components/menu.jsx
touch src/components/header.jsx
touch src/components/orders.jsx
touch src/components/sideCard.jsx
```

Edit `the src\index.js` file and replace the contents with the following code.
Then save `index.js`:

```js
import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import "bootstrap/dist/css/bootstrap.min.css";

ReactDOM.render(<App />, document.getElementById("root"));

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
```

Edit the `src\App.js` file and replace the contents with the following code.
Then save `App.js`.

```js
import React, { Fragment } from "react";
import "./App.css";
import { Container, Row, Col } from "reactstrap";
import Header from "./components/header";
import SideCard from "./components/sideCard";

function App() {
  return (
    <Fragment>
      <Header />
      <div className="my-5 py-5">
        <Container className="px-0">
          <Row
            noGutters
            className="pt-2 pt-md-5 w-100 px-4 px-xl-0 position-relative"
          >
            <Col
              xs={{ order: 2 }}
              md={{ size: 4, order: 1 }}
              tag="aside"
              className="pb-5 mb-5 pb-md-0 mb-md-0 mx-auto mx-md-0"
            >
              <SideCard />
            </Col>

            <Col
              xs={{ order: 1 }}
              md={{ size: 7, offset: 1 }}
              tag="section"
              className="py-5 mb-5 py-md-0 mb-md-0"
            >
              This is the main content!
            </Col>
          </Row>
        </Container>
      </div>
    </Fragment>
  );
}

export default App;
```

Edit `src\components\header.jsx` and replace the contents with the following
code. Then save `header.jsx`.

```js
import React from "react";

import {
  Container,
  Row,
  Col,
  Button,
  Navbar,
  Nav,
  NavbarBrand,
  NavLink,
  NavItem,
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";

const Header = props => {
  const currentUser = props.userName;
  return (
    <header>
      <Navbar
        fixed="top"
        color="light"
        light
        expand="xs"
        className="border-bottom border-gray bg-white"
        style={{ height: 80 }}
      >
        <Container>
          <Row noGutters className="position-relative w-100 align-items-center">
            <Col className="d-none d-lg-flex justify-content-start">
              <Nav className="mrx-auto" navbar>
                {currentUser ? (
                  <NavItem className="d-flex align-items-center">
                    <NavLink className="font-weight-bold" href="/">
                      Welcome, {currentUser}!
                    </NavLink>
                  </NavItem>
                ) : null}

                <NavItem className="d-flex align-items-center">
                  <NavLink className="font-weight-bold" href="/">
                    Home
                  </NavLink>
                </NavItem>

                <NavItem
                  className="d-flex align-items-center"
                  onClick={() => props.onHandleOrder()}
                >
                  <NavLink className="font-weight-bold btn">Menu</NavLink>
                </NavItem>

                <UncontrolledDropdown
                  className="d-flex align-items-center"
                  nav
                  inNavbar
                >
                  <DropdownToggle className="font-weight-bold" nav caret>
                    Account
                  </DropdownToggle>
                  <DropdownMenu right>
                    <DropdownItem
                      className="font-weight-bold text-secondary text-uppercase"
                      header
                      disabled
                    >
                      My Account
                    </DropdownItem>
                    <DropdownItem divider />
                    {currentUser ? <DropdownItem>Profile</DropdownItem> : null}
                    {currentUser ? (
                      <DropdownItem onClick={() => props.onHandleHistory()}>
                        Order History
                      </DropdownItem>
                    ) : null}
                    {currentUser ? (
                      <DropdownItem
                        onClick={() =>
                          props.onHandleLogout ? props.onHandleLogout() : null
                        }
                      >
                        Logout
                      </DropdownItem>
                    ) : (
                      <DropdownItem onClick={() => props.onHandleLogin()}>
                        Login
                      </DropdownItem>
                    )}
                  </DropdownMenu>
                </UncontrolledDropdown>
              </Nav>
            </Col>

            <Col className="d-flex justify-content-xs-start justify-content-lg-center">
              <NavbarBrand
                className="d-inline-block p-0"
                href="/"
                style={{ width: 80 }}
              >
                <img
                  src="https://jah-lex-workshop-2018.s3.amazonaws.com/mob302/images/0001.png"
                  alt="logo"
                  className="position-relative img-fluid"
                />
              </NavbarBrand>
            </Col>

            <Col className="d-none d-lg-flex justify-content-end">
              <Button
                className="info"
                onClick={() =>
                  props.onHandleReview ? props.onHandleReview() : null
                }
              >
                Tell us how were doing
              </Button>
            </Col>
          </Row>
        </Container>
      </Navbar>
    </header>
  );
};
export default Header;
```


Edit the `src\components\sideCard.jsx` file and replace the contents with the following code. Then save sideCard.js:


```js
import React, { Component, Fragment } from "react";
import {
  Button,
  UncontrolledAlert,
  Card,
  CardBody,
  CardTitle,
  CardSubtitle,
  Container,
  Row,
  Col
} from "reactstrap";

class SideCard extends Component {
  state = {};

  render() {
    return (
      <Fragment>
        <UncontrolledAlert color="primary" className="d-none d-lg-block">
          <strong>Recommended for you!</strong>
          <br />
          <Fragment>
            <b>Product Name</b>
            <br></br>
            This is a placeholder for a product description
            <br></br>
            <Button color="success">Add this to Order</Button>
          </Fragment>
        </UncontrolledAlert>

        <Card>
          <CardBody>
            <CardTitle className="h3 mb-2 pt-2 font-weight-bold text-secondary">
              Your Current Cart
            </CardTitle>
            <CardSubtitle
              className="text-secondary mb-2 font-weight-light text-uppercase"
              style={{ fontSize: "0.8rem" }}
            >
              Total: $0.00
            </CardSubtitle>
            <div
              className="text-secondary mb-4"
              style={{ fontSize: "0.75rem" }}
            >
              <Container>
                <Row className="font-weight-bold">
                  <Col>Item Name</Col>
                  <Col>Options</Col>
                  <Col>Price</Col>
                </Row>
              </Container>
            </div>
            <Button color="success" className="font-weight-bold">
              Checkout
            </Button>
          </CardBody>
        </Card>

        <br />
        <Button color="info">Chat to Order!</Button>
      </Fragment>
    );
  }
}

export default SideCard;
```

## Create the AWS Components

In this step, we will begin adding AWS Components using the Amplify framework.
To start, let’s initialize amplify in our project directory.

* For the name of the project, you can use the default name.
* For the environment name, enter `dev`.
* For the default editor, you can choose `None`.
* For type of app, choose `javascript`.
* For the javascript framework, choose `react`
* For the rest of the questions, you can select the default options. This
  includes selecting `Y` when asked if you want to use an AWS profile, and then
  select `default` for the profile name.

```bash
# Change to the React project directory
cd ~/environment/andy-pizza-shop
# Initialize the project configuration for Amplify
amplify init
```

The expected output is:

```text
TeamRole:~/environment/andy-pizza-shop (master) $ amplify init
Note: It is recommended to run this command from the root of your app directory
? Enter a name for the project andy-pizza-shop
? Enter a name for the environment dev
? Choose your default editor: None
? Choose the type of app that you're building javascript
Please tell us about your project
? What javascript framework are you using react
? Source Directory Path:  src
? Distribution Directory Path: build
? Build Command:  npm run-script build
? Start Command: npm run-script start
Using default provider  awscloudformation

For more information on AWS Profiles, see:
https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html

? Do you want to use an AWS profile? Yes
? Please choose the profile you want to use default
Adding backend environment dev to AWS Amplify Console app: dbnfhmqkf85g3
⠴ Initializing project in the cloud...

CREATE_IN_PROGRESS amplify-andy-pizza-shop-dev-180848 AWS::CloudFormation::Stack Wed Dec 04 2019 18:08:49 GMT+0000 (Coordinated Universal Time) User Initiated             
CREATE_IN_PROGRESS DeploymentBucket                   AWS::S3::Bucket            Wed Dec 04 2019 18:08:52 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UnauthRole                         AWS::IAM::Role             Wed Dec 04 2019 18:08:52 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS AuthRole                           AWS::IAM::Role             Wed Dec 04 2019 18:08:53 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UnauthRole                         AWS::IAM::Role             Wed Dec 04 2019 18:08:53 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_IN_PROGRESS AuthRole                           AWS::IAM::Role             Wed Dec 04 2019 18:08:53 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_IN_PROGRESS DeploymentBucket                   AWS::S3::Bucket            Wed Dec 04 2019 18:08:54 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠧ Initializing project in the cloud...

CREATE_COMPLETE DeploymentBucket                   AWS::S3::Bucket            Wed Dec 04 2019 18:09:14 GMT+0000 (Coordinated Universal Time)
CREATE_COMPLETE AuthRole                           AWS::IAM::Role             Wed Dec 04 2019 18:09:15 GMT+0000 (Coordinated Universal Time)
CREATE_COMPLETE UnauthRole                         AWS::IAM::Role             Wed Dec 04 2019 18:09:15 GMT+0000 (Coordinated Universal Time)
CREATE_COMPLETE amplify-andy-pizza-shop-dev-180848 AWS::CloudFormation::Stack Wed Dec 04 2019 18:09:18 GMT+0000 (Coordinated Universal Time)
✔ Successfully created initial AWS cloud resources for deployments.
✔ Initialized provider successfully.
Initialized your environment successfully.

Your project has been successfully initialized and connected to the cloud!

Some next steps:
"amplify status" will show you what you've added already and if it's locally configured or deployed
"amplify <category> add" will allow you to add features like user login or a backend API
"amplify push" will build all your local backend resources and provision it in the cloud
“amplify console” to open the Amplify Console and view your project status
"amplify publish" will build all your local backend and frontend resources (if you have hosting category added) and provision it in the cloud

Pro tip:
Try "amplify add api" to create a backend API and then "amplify publish" to deploy everything

TeamRole:~/environment/andy-pizza-shop (master) $
```

### Add Authentication Service

Next, you will add authentication capabilities for our application using Amazon
Cognito. To do this, we simply need to run the following command from our
project directory:

* Select `Default configuration` for the first choice
* Select `Username` for the user to sign in with a username
* Select, `Yes I want to make additional changes`. We do this because we want
  to require some additional profile fields. In the next step, highlight these
  additional attributes (by using the space bar):
  * Given Name (e.g., First name)
  * Family Name (e.g., Last name)
  * Address
  * Email

```bash
amplify add auth
```

The expected output is:

```text
TeamRole:~/environment/andy-pizza-shop (master) $ amplify add auth
Using service: Cognito, provided by: awscloudformation

 The current configured provider is Amazon Cognito.

 Do you want to use the default authentication and security configuration? Default configuration
 Warning: you will not be able to edit these selections.
 How do you want users to be able to sign in? Username
 Do you want to configure advanced settings? Yes, I want to make some additional changes.
 Warning: you will not be able to edit these selections.
 What attributes are required for signing up? Address (This attribute is not supported by Facebook, Google, Login With Amazon.), Email, Family Name (This attribute is not supported by Login
With Amazon.), Given Name (This attribute is not supported by Login With Amazon.)
 Do you want to enable any of the following capabilities? (Press <space> to select, <a> to toggle all, <i> to invert selection)
Successfully added resource andypizzashop67f708c6 locally

Some next steps:
"amplify push" will build all your local backend resources and provision it in the cloud
"amplify publish" will build all your local backend and frontend resources (if you have hosting category added) and provision it in the cloud

TeamRole:~/environment/andy-pizza-shop (master) $
```

The amplify add auth command only saved files locally. We need to run the
`amplify push` command to deploy our changes to our AWS account. You will be
prompted to complete the changes. Select `Y` and the deployment will begin.

```bash
amplify push
```

The expected output is:

```text
TeamRole:~/environment/andy-pizza-shop (master) $ amplify push
✔ Successfully pulled backend environment dev from the cloud.

Current Environment: dev

| Category | Resource name         | Operation | Provider plugin   |
| -------- | --------------------- | --------- | ----------------- |
| Auth     | andypizzashop67f708c6 | Create    | awscloudformation |
? Are you sure you want to continue? Yes
⠼ Updating resources in the cloud. This may take a few minutes...

UPDATE_IN_PROGRESS amplify-andy-pizza-shop-dev-180848 AWS::CloudFormation::Stack Wed Dec 04 2019 18:18:00 GMT+0000 (Coordinated Universal Time) User Initiated             
CREATE_IN_PROGRESS UpdateRolesWithIDPFunctionRole     AWS::IAM::Role             Wed Dec 04 2019 18:18:04 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS authandypizzashop67f708c6          AWS::CloudFormation::Stack Wed Dec 04 2019 18:18:04 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UpdateRolesWithIDPFunctionRole     AWS::IAM::Role             Wed Dec 04 2019 18:18:05 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠦ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS authandypizzashop67f708c6 AWS::CloudFormation::Stack Wed Dec 04 2019 18:18:05 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠧ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS amplify-andy-pizza-shop-dev-180848-authandypizzashop67f708c6-UJ1DKMV2PP0G AWS::CloudFormation::Stack Wed Dec 04 2019 18:18:05 GMT+0000 (Coordinated Universal Time) User Initiated
⠏ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS SNSRole AWS::IAM::Role Wed Dec 04 2019 18:18:10 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS SNSRole AWS::IAM::Role Wed Dec 04 2019 18:18:11 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠧ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE UpdateRolesWithIDPFunctionRole AWS::IAM::Role Wed Dec 04 2019 18:18:30 GMT+0000 (Coordinated Universal Time)
⠇ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE SNSRole AWS::IAM::Role Wed Dec 04 2019 18:18:34 GMT+0000 (Coordinated Universal Time)
⠹ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPool AWS::Cognito::UserPool Wed Dec 04 2019 18:18:38 GMT+0000 (Coordinated Universal Time)
⠴ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPool AWS::Cognito::UserPool Wed Dec 04 2019 18:18:40 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠸ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE    UserPool          AWS::Cognito::UserPool       Wed Dec 04 2019 18:18:40 GMT+0000 (Coordinated Universal Time)
CREATE_IN_PROGRESS UserPoolClient    AWS::Cognito::UserPoolClient Wed Dec 04 2019 18:18:43 GMT+0000 (Coordinated Universal Time)
CREATE_IN_PROGRESS UserPoolClientWeb AWS::Cognito::UserPoolClient Wed Dec 04 2019 18:18:44 GMT+0000 (Coordinated Universal Time)
⠦ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClient AWS::Cognito::UserPoolClient Wed Dec 04 2019 18:18:45 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    UserPoolClient AWS::Cognito::UserPoolClient Wed Dec 04 2019 18:18:45 GMT+0000 (Coordinated Universal Time)                            
⠴ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClientWeb  AWS::Cognito::UserPoolClient Wed Dec 04 2019 18:18:46 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    UserPoolClientWeb  AWS::Cognito::UserPoolClient Wed Dec 04 2019 18:18:46 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UserPoolClientRole AWS::IAM::Role               Wed Dec 04 2019 18:18:48 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UserPoolClientRole AWS::IAM::Role               Wed Dec 04 2019 18:18:49 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠧ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE UserPoolClientRole AWS::IAM::Role Wed Dec 04 2019 18:19:11 GMT+0000 (Coordinated Universal Time)
⠏ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClientLambda AWS::Lambda::Function Wed Dec 04 2019 18:19:16 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UserPoolClientLambda AWS::Lambda::Function Wed Dec 04 2019 18:19:18 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    UserPoolClientLambda AWS::Lambda::Function Wed Dec 04 2019 18:19:18 GMT+0000 (Coordinated Universal Time)                            
⠹ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClientLambdaPolicy AWS::IAM::Policy Wed Dec 04 2019 18:19:22 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UserPoolClientLambdaPolicy AWS::IAM::Policy Wed Dec 04 2019 18:19:23 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠙ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE UserPoolClientLambdaPolicy AWS::IAM::Policy Wed Dec 04 2019 18:19:43 GMT+0000 (Coordinated Universal Time)
⠸ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClientLogPolicy AWS::IAM::Policy Wed Dec 04 2019 18:19:47 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UserPoolClientLogPolicy AWS::IAM::Policy Wed Dec 04 2019 18:19:48 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
⠹ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE UserPoolClientLogPolicy AWS::IAM::Policy Wed Dec 04 2019 18:20:08 GMT+0000 (Coordinated Universal Time)
⠼ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClientInputs Custom::LambdaCallout Wed Dec 04 2019 18:20:12 GMT+0000 (Coordinated Universal Time)
⠦ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UserPoolClientInputs Custom::LambdaCallout      Wed Dec 04 2019 18:20:16 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    UserPoolClientInputs Custom::LambdaCallout      Wed Dec 04 2019 18:20:16 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS IdentityPool         AWS::Cognito::IdentityPool Wed Dec 04 2019 18:20:19 GMT+0000 (Coordinated Universal Time)                            
⠏ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS IdentityPool        AWS::Cognito::IdentityPool               Wed Dec 04 2019 18:20:20 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    IdentityPool        AWS::Cognito::IdentityPool               Wed Dec 04 2019 18:20:21 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS IdentityPoolRoleMap AWS::Cognito::IdentityPoolRoleAttachment Wed Dec 04 2019 18:20:24 GMT+0000 (Coordinated Universal Time)                            
⠙ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS IdentityPoolRoleMap                                                       AWS::Cognito::IdentityPoolRoleAttachment Wed Dec 04 2019 18:20:26 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    IdentityPoolRoleMap                                                       AWS::Cognito::IdentityPoolRoleAttachment Wed Dec 04 2019 18:20:26 GMT+0000 (Coordinated Universal Time)                            
CREATE_COMPLETE    amplify-andy-pizza-shop-dev-180848-authandypizzashop67f708c6-UJ1DKMV2PP0G AWS::CloudFormation::Stack               Wed Dec 04 2019 18:20:28 GMT+0000 (Coordinated Universal Time)                            
⠧ Updating resources in the cloud. This may take a few minutes...

CREATE_COMPLETE authandypizzashop67f708c6 AWS::CloudFormation::Stack Wed Dec 04 2019 18:20:45 GMT+0000 (Coordinated Universal Time)
⠏ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UpdateRolesWithIDPFunction AWS::Lambda::Function Wed Dec 04 2019 18:20:47 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UpdateRolesWithIDPFunction AWS::Lambda::Function Wed Dec 04 2019 18:20:48 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    UpdateRolesWithIDPFunction AWS::Lambda::Function Wed Dec 04 2019 18:20:48 GMT+0000 (Coordinated Universal Time)                            
⠙ Updating resources in the cloud. This may take a few minutes...

CREATE_IN_PROGRESS UpdateRolesWithIDPFunctionOutputs Custom::LambdaCallout Wed Dec 04 2019 18:20:50 GMT+0000 (Coordinated Universal Time)                            
CREATE_IN_PROGRESS UpdateRolesWithIDPFunctionOutputs Custom::LambdaCallout Wed Dec 04 2019 18:20:54 GMT+0000 (Coordinated Universal Time) Resource creation Initiated
CREATE_COMPLETE    UpdateRolesWithIDPFunctionOutputs Custom::LambdaCallout Wed Dec 04 2019 18:20:54 GMT+0000 (Coordinated Universal Time)                            
⠼ Updating resources in the cloud. This may take a few minutes...

UPDATE_COMPLETE_CLEANUP_IN_PROGRESS amplify-andy-pizza-shop-dev-180848 AWS::CloudFormation::Stack Wed Dec 04 2019 18:20:57 GMT+0000 (Coordinated Universal Time)
UPDATE_COMPLETE                     amplify-andy-pizza-shop-dev-180848 AWS::CloudFormation::Stack Wed Dec 04 2019 18:20:57 GMT+0000 (Coordinated Universal Time)
✔ All resources are updated in the cloud


TeamRole:~/environment/andy-pizza-shop (master) $
```

You can run the `amplify status` command to get a list of all pending and
completed changes for your project.

### Add the Authentication to our App

Next, you will take advantage of the newly deployed authentication feature.
To do this, use the Amplify Authenticator component which provides built-in
sign up and login capabilities.

Replace the contents of the `App.js` file with the following and save `App.js`.
This code does the following:

* Configures the Authenticator component (provided by the Amplify libraries) - `<Authenticator signUpConfig={signUpConfig} />`
* Handles the login request from our Header navigation - `onHandleLogin={this.handleLogin}`
* Responds to a successful login by setting the current username in state and
  the header. To do this, it uses the Amplify Hub class - `Hub.listen("auth", ({ payload: { event, data } })``

```js
import React, { Fragment, Component } from "react";
import "./App.css";
import { Container, Row, Col } from "reactstrap";
import Header from "./components/header";
import SideCard from "./components/sideCard";
import Amplify, { Auth, Hub } from "aws-amplify";
import { Authenticator } from "aws-amplify-react";
import awsconfig from "./aws-exports";

Amplify.configure(awsconfig);

const signUpConfig = {
  header: "Welcome!",
  signUpFields: [
    {
      label: "First Name",
      key: "given_name",
      placeholder: "First Name",
      required: true,
      displayOrder: 5
    },
    {
      label: "Last Name",
      key: "family_name",
      placeholder: "Last Name",
      required: true,
      displayOrder: 6
    },
    {
      label: "Address",
      key: "address",
      placeholder: "Address",
      required: true,
      displayOrder: 7
    }
  ]
};

class App extends Component {
  state = {
    showType: "",
    loggedIn: false,
    currentUser: null
  };

  loadCurrentUser() {
    Auth.currentAuthenticatedUser().then(userInfo => {
      this.setState({
        loggedIn: true,
        currentUser: userInfo.username,
        currentUserData: userInfo
      });
    });
  }
  componentDidMount = () => {
    Hub.listen("auth", ({ payload: { event, data } }) => {
      switch (event) {
        case "signIn":
          this.setState({
            currentUser: data.username,
            currentUserData: data,
            loggedIn: true
          });
          break;
        case "signOut":
          this.setState({
            currentUser: null,
            loggedIn: false
          });
          break;
        default:
          break;
      }
    });
    this.loadCurrentUser();
  };

  handleLogin = () => {
    this.setState({
      showType: "login"
    });
  };

  handleLogout = () => {
    this.setState({
      showType: "login"
    });
  };

  render() {
    return (
      <Fragment>
        <Header
          onHandleLogin={this.handleLogin}
          onHandleLogout={this.handleLogout}
          loggedIn={this.state.loggedIn}
          userName={this.state.currentUser}
        />
        <div className="my-5 py-5">
          <Container className="px-0">
            <Row
              noGutters
              className="pt-2 pt-md-5 w-100 px-4 px-xl-0 position-relative"
            >
              <Col
                xs={{ order: 2 }}
                md={{ size: 4, order: 1 }}
                tag="aside"
                className="pb-5 mb-5 pb-md-0 mb-md-0 mx-auto mx-md-0"
              >
                <SideCard />
              </Col>

              <Col
                xs={{ order: 1 }}
                md={{ size: 7, offset: 1 }}
                tag="section"
                className="py-5 mb-5 py-md-0 mb-md-0"
              >
                {this.state.showType === "" ? "This is the main content" : null}
                {this.state.showType === "login" ? (
                  <Authenticator signUpConfig={signUpConfig} />
                ) : null}
              </Col>
            </Row>
          </Container>
        </div>
      </Fragment>
    );
  }
}

export default App;
```

Next, test the application. Now you can return to the preview tab for your
application and verify that you can sign up and login to your application:

1. Select "Account->Login" in the header.
2. On the sign-in screen, click the "Create account" button:
3. Enter the required details.
  * Use `edge21` as the username. This is important for later purposes.
  * Password: `a3150261-ABFC-4F24-9C97-152DDF40FB94`
  * Make sure to use an email address that you have access to in order to
    receive the verification code. You can re-use the same e-mail address
    for multiple users.
  * Press CREATE ACCOUNT when complete


### Adding Backend Data Services

:WARNING: Go to DynamoDB and clean items in 2 tables: Proiduct and Variation.
Delete items in the tables. Then, re-add items through AppSync.



Using Amplify, we are going to deploy an AWS AppSync API.

There are many features and benefits of AppSync and GraphQL. These are not
covered in this workshop, but you can learn more at https://aws.amazon.com/appsync/
and https://docs.aws.amazon.com/appsync/latest/devguide/designing-a-graphql-api.html.

Run the following command to add an API.
* Choose `GraphQL`, and enter the API name as `andypizzashop`
* Choose `Amazon Cognito User Pool`. This will enforce security in our application
  by requiring the user to have authenticated before adding items in our API.
* Enter `No I am done` when prompted for additional changes
* Choose `N` for annotated GraphQL Schema and `N` for guided schema creation.
  Leave the custom type name as `MyType` and press enter. This will create a
  base schema, but we will replace that with our own.

```bash
amplify add api
```

The expected output is:

```
TeamRole:~/environment/andy-pizza-shop (master) $ amplify add api
? Please select from one of the below mentioned services: GraphQL
? Provide API name: andypizzashop
? Choose the default authorization type for the API Amazon Cognito User Pool
Use a Cognito user pool configured as a part of this project.
? Do you want to configure advanced settings for the GraphQL API No, I am done.
? Do you have an annotated GraphQL schema? No
? Do you want a guided schema creation? No
? Provide a custom type name MyType
Creating a base schema for you...

The following types do not have '@auth' enabled. Consider using @auth with @model
         - MyType
Learn more about @auth here: https://aws-amplify.github.io/docs/cli-toolchain/graphql#auth


GraphQL schema compiled successfully.

Edit your schema at /home/ec2-user/environment/andy-pizza-shop/amplify/backend/api/andypizzashop/schema.graphql or place .graphql files in a directory at /home/ec2-user/environment/andy-pizza-shop/amplify/backend/api/andypizzashop/schema
Successfully added resource andypizzashop locally

Some next steps:
"amplify push" will build all your local backend resources and provision it in the cloud
"amplify publish" will build all your local backend and frontend resources (if you have hosting category added) and provision it in the cloud

TeamRole:~/environment/andy-pizza-shop (master) $
```

Notice the location of the schema file that Amplify created. This is the schema
definition that amplify will use to create the AppSync schema. To edit this,
you can click the file location and it will open a context menu where you can select Open

```
/home/ec2-user/environment/andy-pizza-shop/amplify/backend/api/andypizzashop/schema.graphql
```

Replace the schema in `schema.graphql` with the following code and save `schema.graphql`:

```js
type Order @model @auth(rules: [{ allow: owner }]) {
  id: ID!
  name: String!
  user: String!
  phone: AWSPhone
  email: AWSEmail
  orderDate: AWSDateTime
  orderTotal: Float!
  deliveryType: String!
  deliveryDate: AWSDateTime
  status: String!
  items: [Item] @connection(name: "OrderItems")
}
type Item @model @auth(rules: [{ allow: owner }]){
  id: ID!
  itemName: String!
  comments: String
  quantity: Int!
  size: String!
  unitPrice: Float!
  totalPrice: Float!
  order: Order @connection(name: "OrderItems")
  toppings: [Topping] @connection(name: "ItemToppings")
}
type Topping @model @auth(rules: [{ allow: owner }]){
  id: ID!
  toppingName: String!
  toppingWeight: String
  toppingSpread: String
  item: Item @connection(name: "ItemToppings")
}
type Product @model {
  id: ID!
  productId: String!
  productName: String!
  category: String!
  description: String
  defaultPrice: Float
  sizes: [Variation] @connection(name: "ProductSizes")
}
type Variation @model {
  id: ID!
  size: String!
  price: Float
  product: Product @connection(name: "ProductSizes")
}
```

Notice the `@` signs in this schema? The Amplify framework supports these GraphQL
annotations - which are directives that tell amplify to configure our AppSync API in a certain way:
* `@model` - creates the data model using DynamoDB
* `@connection` - creates relationship between types
* `@auth` - creates fields identifying access control and the appropriate query controls

To learn more about these, check out https://aws-amplify.github.io/docs/cli-toolchain/graphql#directives

Make sure you save the `schema.graphql` file and then run the following to push
our changes into AWS. Leave the default responses for the next set of questions.

```bash
amplify push
```

The expected output is:

```text

```

Once you get through all the questions, deployment will start. This will take a few minutes.

If you are bored, you can take some time to think about what is being provisioned
here. Although Amplify makes it seem simple, it is not trivial. Amplify is deploying
the schema, the backend Dynamo DB tables, the AppSync resolvers (using Velocity
Templates), and the AppSync authentication integration with Cognito.

Once complete, you will receive the GraphQL **endpoint information** in the terminal
window. This endpoint is now accessible by an authenticated user.

GraphQL endpoint: https://rgtj72cbafelhgyxkslln57r7y.appsync-api.us-west-2.amazonaws.com/graphql

Next, open the file `src/aws-exports.js` and find the `aws_user_pools_web_client_id` value.
Copy the value (e.g. `v9fg5hgpn9g7apj57cmvqg67`) as you will need it for the next step.

```
const awsmobile = {
    "aws_project_region": "us-west-2",
    "aws_cognito_identity_pool_id": "us-west-2:cd01dac6-51b8-4ae7-b8a2-90d443815816",
    "aws_cognito_region": "us-west-2",
    "aws_user_pools_id": "us-west-2_3mTUp5m6q",
    "aws_user_pools_web_client_id": "v9fg5hgpn9g7apj57cmvqg67",
    "oauth": {},
    "aws_appsync_graphqlEndpoint": "https://rgtj72cbafelhgyxkslln57r7y.appsync-api.us-west-2.amazonaws.com/graphql",
    "aws_appsync_region": "us-west-2",
    "aws_appsync_authenticationType": "AMAZON_COGNITO_USER_POOLS"
};
```

Now visit the AWS AppSync console to view your AppSync API
at https://console.aws.amazon.com/appsync/home?. Click on the name of your API.

Select **Queries** from the left column, and then click **Login with User Pools**.

Then enter in the following values:
* ClientId: enter the value you copied for `aws_user_pools_web_client_id`, i.e. `v9fg5hgpn9g7apj57cmvqg67`
* Username: `edge21`
* Password: the password that you entered when you registered

Click **Login**.

We need to add some product data so we don’t have an empty menu. To do this,
paste in the following set of queries and then press the **Orange Play** button to
run **CreateProducts**.


```js
mutation CreateProducts {
CreateProduct_0: createProduct(input: {id: "cef87f6f-acd9-4ff2-9eb3-29f97e5ee5bb",productId: "0007",productName: "Cheese Sticks",category: "SIDE",description: "Cheesey and scrupmtious, great as a side or a full meal",defaultPrice: 6}) {id}
CreateVariation_0_0: createVariation(input: {size: "Four Pack",price: 3.39,variationProductId: "cef87f6f-acd9-4ff2-9eb3-29f97e5ee5bb"}){id}
CreateVariation_0_1: createVariation(input: {size: "Dozen",price: 6.59,variationProductId: "cef87f6f-acd9-4ff2-9eb3-29f97e5ee5bb"}){id}
CreateProduct_1: createProduct(input: {id: "f635e0be-86e0-4ae0-877e-9000f4afdba7",productId: "0006",productName: "Garden Salad",category: "SIDE",description: "Fresh greens and tomatoes and cucumbers",defaultPrice: 6}) {id}
CreateVariation_1_0: createVariation(input: {size: "Half Size",price: 4.99,variationProductId: "f635e0be-86e0-4ae0-877e-9000f4afdba7"}){id}
CreateVariation_1_1: createVariation(input: {size: "Full Size",price: 7.99,variationProductId: "f635e0be-86e0-4ae0-877e-9000f4afdba7"}){id}
CreateProduct_2: createProduct(input: {id: "92d12047-5509-478f-9bde-2b1a8bed578e",productId: "0010",productName: "Lemon Lime Spritzer",category: "SIDE",description: "A fruity sode with lemon and lime",defaultPrice: 3}) {id}
CreateVariation_2_0: createVariation(input: {size: "2 Liter",price: 1.99,variationProductId: "92d12047-5509-478f-9bde-2b1a8bed578e"}){id}
CreateProduct_3: createProduct(input: {id: "d3239e2c-95e0-4d88-9dd0-286fe052bf45",productId: "0014",productName: "Magnum Club",category: "SUB",description: "This thing is loaded with beef, turkey, bacon and veggies",defaultPrice: 9}) {id}
CreateVariation_3_0: createVariation(input: {size: "Small",price: 4.99,variationProductId: "d3239e2c-95e0-4d88-9dd0-286fe052bf45"}){id}
CreateVariation_3_1: createVariation(input: {size: "Regular",price: 8.59,variationProductId: "d3239e2c-95e0-4d88-9dd0-286fe052bf45"}){id}
CreateProduct_4: createProduct(input: {id: "cffb7343-d8f3-48a5-a632-1ad39e6a189b",productId: "0002",productName: "Supreme Pizza",category: "PIZZA",description: "Just about every topping you'll need to satisfy your appetite.",defaultPrice: 10}) {id}
CreateVariation_4_0: createVariation(input: {size: "Large",price: 7.99,variationProductId: "cffb7343-d8f3-48a5-a632-1ad39e6a189b"}){id}
CreateVariation_4_1: createVariation(input: {size: "Small",price: 5.99,variationProductId: "cffb7343-d8f3-48a5-a632-1ad39e6a189b"}){id}
CreateVariation_4_2: createVariation(input: {size: "Medium",price: 6.99,variationProductId: "cffb7343-d8f3-48a5-a632-1ad39e6a189b"}){id}
CreateProduct_5: createProduct(input: {id: "c57ee325-407c-4a40-a428-c5e7b2c5338a",productId: "0015",productName: "Pizza Club",category: "SUB",description: "Pizza sauce with pepperoni and cheese, just like a pizza",defaultPrice: 8}) {id}
CreateVariation_5_0: createVariation(input: {size: "Small",price: 3.99,variationProductId: "c57ee325-407c-4a40-a428-c5e7b2c5338a"}){id}
CreateVariation_5_1: createVariation(input: {size: "Regular",price: 6.99,variationProductId: "c57ee325-407c-4a40-a428-c5e7b2c5338a"}){id}
CreateProduct_6: createProduct(input: {id: "5ccf7ec4-9318-4695-b664-59d6ce60baba",productId: "0001",productName: "Ultimate Pizza",category: "PIZZA",description: "An array of delectable toppings served piping hot on top of our classic crust.",defaultPrice: 10}) {id}
CreateVariation_6_0: createVariation(input: {size: "Medium",price: 7.59,variationProductId: "5ccf7ec4-9318-4695-b664-59d6ce60baba"}){id}
CreateVariation_6_1: createVariation(input: {size: "Small",price: 6.59,variationProductId: "5ccf7ec4-9318-4695-b664-59d6ce60baba"}){id}
CreateVariation_6_2: createVariation(input: {size: "Large",price: 8.59,variationProductId: "5ccf7ec4-9318-4695-b664-59d6ce60baba"}){id}
CreateProduct_7: createProduct(input: {id: "ae3116b4-00e7-4ac4-af35-9ebf067b1ea9",productId: "0008",productName: "Meat Lovers Pizza",category: "PIZZA",description: "There is pepperoni, and bacon, and sausage, and backon, and ham, and oh yeah, did we mention bacon?",defaultPrice: 10}) {id}
CreateVariation_7_0: createVariation(input: {size: "Large",price: 7.99,variationProductId: "ae3116b4-00e7-4ac4-af35-9ebf067b1ea9"}){id}
CreateVariation_7_1: createVariation(input: {size: "Small",price: 5.99,variationProductId: "ae3116b4-00e7-4ac4-af35-9ebf067b1ea9"}){id}
CreateVariation_7_2: createVariation(input: {size: "Medium",price: 6.99,variationProductId: "ae3116b4-00e7-4ac4-af35-9ebf067b1ea9"}){id}
CreateProduct_8: createProduct(input: {id: "0a311e6f-085e-4820-b2aa-4ec325b82772",productId: "0005",productName: "Breadsticks",category: "SIDE",description: "Hot and fresh, full of buttery flavor",defaultPrice: 5}) {id}
CreateVariation_8_0: createVariation(input: {size: "Dozen",price: 5.99,variationProductId: "0a311e6f-085e-4820-b2aa-4ec325b82772"}){id}
CreateVariation_8_1: createVariation(input: {size: "Half Dozen",price: 3.99,variationProductId: "0a311e6f-085e-4820-b2aa-4ec325b82772"}){id}
CreateProduct_9: createProduct(input: {id: "82d3c5f3-68b8-4b4f-8d0d-c10cbda9324e",productId: "0009",productName: "Regular Cola",category: "SIDE",description: "Have one of these with a smile",defaultPrice: 3}) {id}
CreateVariation_9_0: createVariation(input: {size: "2 Liter",price: 2.99,variationProductId: "82d3c5f3-68b8-4b4f-8d0d-c10cbda9324e"}){id}
CreateProduct_10: createProduct(input: {id: "92d27977-d035-4aa9-a3ae-8d063c4a7c8f",productId: "0013",productName: "Veggie Sub",category: "SUB",description: "This sub has just bread and veggies - good for you!",defaultPrice: 7}) {id}
CreateVariation_10_0: createVariation(input: {size: "Regular",price: 6.99,variationProductId: "92d27977-d035-4aa9-a3ae-8d063c4a7c8f"}){id}
CreateVariation_10_1: createVariation(input: {size: "Small",price: 3.99,variationProductId: "92d27977-d035-4aa9-a3ae-8d063c4a7c8f"}){id}
CreateProduct_11: createProduct(input: {id: "2a16a92f-ff88-457d-8347-2946ee692453",productId: "0011",productName: "Diet Cola",category: "SIDE",description: "Have one of these with a smile and no guilt",defaultPrice: 3}) {id}
CreateVariation_11_0: createVariation(input: {size: "2 Liter",price: 2.99,variationProductId: "2a16a92f-ff88-457d-8347-2946ee692453"}){id}
CreateProduct_12: createProduct(input: {id: "058081d9-9e1b-4900-9733-4a7eb21ed8bd",productId: "0004",productName: "Cheese Pizza",category: "PIZZA",description: "Mozzarella cheese, and sauce, on crust... what more do you need?",defaultPrice: 10}) {id}
CreateVariation_12_0: createVariation(input: {size: "Medium",price: 6.99,variationProductId: "058081d9-9e1b-4900-9733-4a7eb21ed8bd"}){id}
CreateVariation_12_1: createVariation(input: {size: "Large",price: 7.99,variationProductId: "058081d9-9e1b-4900-9733-4a7eb21ed8bd"}){id}
CreateVariation_12_2: createVariation(input: {size: "Small",price: 5.99,variationProductId: "058081d9-9e1b-4900-9733-4a7eb21ed8bd"}){id}
CreateProduct_13: createProduct(input: {id: "64b18436-279c-45b8-a15b-e30b02729987",productId: "0012",productName: "Andys Sub",category: "SUB",description: "Andy Classic Sub, with turkey and bacon and tomatoes and mayo",defaultPrice: 8}) {id}
CreateVariation_13_0: createVariation(input: {size: "Small",price: 4.99,variationProductId: "64b18436-279c-45b8-a15b-e30b02729987"}){id}
CreateVariation_13_1: createVariation(input: {size: "Regular",price: 7.99,variationProductId: "64b18436-279c-45b8-a15b-e30b02729987"}){id}
CreateProduct_14: createProduct(input: {id: "4c4442f6-41cc-456c-a41b-c57b8680a30a",productId: "0003",productName: "Veggie Supreme",category: "PIZZA",description: "Well, it's just vegetables.",defaultPrice: 10}) {id}
CreateVariation_14_0: createVariation(input: {size: "Medium",price: 6.99,variationProductId: "4c4442f6-41cc-456c-a41b-c57b8680a30a"}){id}
CreateVariation_14_1: createVariation(input: {size: "Large",price: 7.99,variationProductId: "4c4442f6-41cc-456c-a41b-c57b8680a30a"}){id}
CreateVariation_14_2: createVariation(input: {size: "Small",price: 5.99,variationProductId: "4c4442f6-41cc-456c-a41b-c57b8680a30a"}){id}
CreateProduct_15: createProduct(input: {id: "3b16a92f-ff88-457d-8347-2946ee692453",productId: "0016",productName: "Choco Cake",category: "SIDE",description: "Chocolate mixed in with chocolate, and cake, and topped with chocoloate",defaultPrice: 5}) {id}
CreateVariation_15_0: createVariation(input: {size: "Regular",price: 5.99,variationProductId: "3b16a92f-ff88-457d-8347-2946ee692453"}){id}
CreateProduct_16: createProduct(input: {id: "4c16a92f-ff88-457d-8347-2946ee692453",productId: "0017",productName: "Vanilla Bean Pudding",category: "SIDE",description: "A light, fluffy dessert filled with vanilla cream flavoring and topped with cinnamon",defaultPrice: 5}) {id}
CreateVariation_16_0: createVariation(input: {size: "Regular",price: 5.99,variationProductId: "4c16a92f-ff88-457d-8347-2946ee692453"}){id}
CreateProduct_17: createProduct(input: {id: "5d16a92f-ff88-457d-8347-2946ee692453",productId: "0018",productName: "Carryover Cafe Brownies",category: "SIDE",description: "Brownies infused with caramel and chocolate chips",defaultPrice: 5}) {id}
CreateVariation_17_0: createVariation(input: {size: "Regular",price: 6.49,variationProductId: "5d16a92f-ff88-457d-8347-2946ee692453"}){id}
}
```

The response was:

```json
{
  "data": {
    "CreateProduct_0": {
      "id": "cef87f6f-acd9-4ff2-9eb3-29f97e5ee5bb"
    },
    "CreateVariation_0_0": {
      "id": "331fe9b9-e7fd-4a89-a0d0-3a7e5a361344"
    },
    "CreateVariation_0_1": {
      "id": "11939b84-a6c3-4907-9a06-35e2b0d99f18"
    },
    "CreateProduct_1": {
      "id": "f635e0be-86e0-4ae0-877e-9000f4afdba7"
    },
    "CreateVariation_1_0": {
      "id": "e750eab7-ffe2-406f-a0aa-865da4340688"
    },
    "CreateVariation_1_1": {
      "id": "53ef2c55-0c8d-45ce-9294-ba139583d437"
    },
    "CreateProduct_2": {
      "id": "92d12047-5509-478f-9bde-2b1a8bed578e"
    },
    "CreateVariation_2_0": {
      "id": "73cd1470-7606-4ed9-93de-27088657067a"
    },
    "CreateProduct_3": {
      "id": "d3239e2c-95e0-4d88-9dd0-286fe052bf45"
    },
    "CreateVariation_3_0": {
      "id": "331d571d-bf3f-4e14-88ff-e5834b1c671e"
    },
    "CreateVariation_3_1": {
      "id": "1fca7b84-429a-4729-9b14-de3a6d5c8696"
    },
    "CreateProduct_4": {
      "id": "cffb7343-d8f3-48a5-a632-1ad39e6a189b"
    },
    "CreateVariation_4_0": {
      "id": "dccf7923-11bb-42c7-9f5d-a6f42c085b8c"
    },
    "CreateVariation_4_1": {
      "id": "396fe703-cdf4-4c91-b18a-68ece699d21b"
    },
    "CreateVariation_4_2": {
      "id": "3cd49669-1771-46c7-9070-21b74382aaeb"
    },
    "CreateProduct_5": {
      "id": "c57ee325-407c-4a40-a428-c5e7b2c5338a"
    },
    "CreateVariation_5_0": {
      "id": "919fae9f-d237-4cf0-bff4-050706e01fa4"
    },
    "CreateVariation_5_1": {
      "id": "28627e20-3a7c-4706-a395-d3e574185cbc"
    },
    "CreateProduct_6": {
      "id": "5ccf7ec4-9318-4695-b664-59d6ce60baba"
    },
    "CreateVariation_6_0": {
      "id": "792f5d65-5159-432c-9b30-dc61257d4b55"
    },
    "CreateVariation_6_1": {
      "id": "db66e28f-216d-45c8-b542-9b31888615a3"
    },
    "CreateVariation_6_2": {
      "id": "2aa61f2d-b135-4dc0-aa42-cbd6479ae42c"
    },
    "CreateProduct_7": {
      "id": "ae3116b4-00e7-4ac4-af35-9ebf067b1ea9"
    },
    "CreateVariation_7_0": {
      "id": "b6495ac1-bd8a-4090-b610-099c591d63c8"
    },
    "CreateVariation_7_1": {
      "id": "dd2bce77-3183-46c3-b135-1d1b59393894"
    },
    "CreateVariation_7_2": {
      "id": "42bacaad-69d8-40fb-8657-e99330326bd2"
    },
    "CreateProduct_8": {
      "id": "0a311e6f-085e-4820-b2aa-4ec325b82772"
    },
    "CreateVariation_8_0": {
      "id": "20659c8f-148f-499b-99b7-b103dd13fa6e"
    },
    "CreateVariation_8_1": {
      "id": "90d8fee5-a9b2-42b0-8dfb-f7908797ca96"
    },
    "CreateProduct_9": {
      "id": "82d3c5f3-68b8-4b4f-8d0d-c10cbda9324e"
    },
    "CreateVariation_9_0": {
      "id": "35bbf62a-a139-43d5-93b6-41223f988184"
    },
    "CreateProduct_10": {
      "id": "92d27977-d035-4aa9-a3ae-8d063c4a7c8f"
    },
    "CreateVariation_10_0": {
      "id": "02c236e3-b7a1-4cfd-afe6-6608301f135c"
    },
    "CreateVariation_10_1": {
      "id": "707c378f-f65e-4a99-8472-d74db0b98419"
    },
    "CreateProduct_11": {
      "id": "2a16a92f-ff88-457d-8347-2946ee692453"
    },
    "CreateVariation_11_0": {
      "id": "c5f771fa-d5a9-4aef-9780-03266c927526"
    },
    "CreateProduct_12": {
      "id": "058081d9-9e1b-4900-9733-4a7eb21ed8bd"
    },
    "CreateVariation_12_0": {
      "id": "f1129ac2-0ecf-4b36-bb0b-4c9402595540"
    },
    "CreateVariation_12_1": {
      "id": "4e43b2a7-b0c3-4842-9319-7fd3a83aefbf"
    },
    "CreateVariation_12_2": {
      "id": "82e9ebf3-43a3-42d6-93b1-6fec3c42a299"
    },
    "CreateProduct_13": {
      "id": "64b18436-279c-45b8-a15b-e30b02729987"
    },
    "CreateVariation_13_0": {
      "id": "25f3fa64-79e8-42a7-b126-462b24fe3f95"
    },
    "CreateVariation_13_1": {
      "id": "ec89b2a8-204f-4733-98b1-5c431cd34cbf"
    },
    "CreateProduct_14": {
      "id": "4c4442f6-41cc-456c-a41b-c57b8680a30a"
    },
    "CreateVariation_14_0": {
      "id": "3ceb4767-4f78-4920-a3d4-4829aba9e6e6"
    },
    "CreateVariation_14_1": {
      "id": "b15a710d-613c-4db9-a69b-5609b0072216"
    },
    "CreateVariation_14_2": {
      "id": "ebc478ae-a64d-4827-b74b-b9c1a0b170db"
    },
    "CreateProduct_15": {
      "id": "3b16a92f-ff88-457d-8347-2946ee692453"
    },
    "CreateVariation_15_0": {
      "id": "9a3f3261-537d-4a67-9f2f-50eb0de64e77"
    },
    "CreateProduct_16": {
      "id": "4c16a92f-ff88-457d-8347-2946ee692453"
    },
    "CreateVariation_16_0": {
      "id": "ecee4282-da35-46b8-a757-ff3dfefd344b"
    },
    "CreateProduct_17": {
      "id": "5d16a92f-ff88-457d-8347-2946ee692453"
    },
    "CreateVariation_17_0": {
      "id": "7b00e616-7a6d-4341-9db1-a5310441ecc0"
    }
  }
}
```

This will load our initial product data - you should see successful logs in the
right hand column of the AppSync query console.

Now that we have a backend data store and an API layer to access it, let’s put
it into our application.

### Adding data to our app

Return to your Cloud9 environment. Next, modify the code to display our menu of items. We obviously need this if we are going to allow our users to order something!

Replace the following code in the `components/menu.jsx` file and save the file:

```js
import React, { Component, Fragment } from "react";
import { Tabs, Tab } from "react-bootstrap";
import { Button, Container, Row, Col } from "reactstrap";
import { API, graphqlOperation } from "aws-amplify";

class MenuItem extends Component {
  state = {
    isLoaded: false
  };

  imageLocation = "https://jah-lex-workshop-2018.s3.amazonaws.com/mob302/images/"

  listProductsWithVariant = `query ListProducts(
    $filter: ModelProductFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listProducts(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        productId
        productName
        category
        description
        defaultPrice
        sizes {
            items {
              price
              size
            }
          }
      }
      nextToken
    }
  }
  `;

  getDefaultSizes(menuItems) {
    var sizeSel = [];
    for (var menuItem in menuItems) {
      var cItem = menuItems[menuItem];
      var sizeSelItem = {
        itemId: cItem.productId,
        size: cItem.sizes.items[0].size,
        price: cItem.sizes.items[0].price
      };
      sizeSel.push(sizeSelItem);
    }
    return sizeSel;
  }
  componentDidMount() {
    const limit = {
      limit: 100
    };
    API.graphql(graphqlOperation(this.listProductsWithVariant, limit)).then(
      result => {
        const sizeSels = this.getDefaultSizes(result.data.listProducts.items);
        this.setState({
          menuItems: result.data.listProducts.items,
          selectedSize: sizeSels,
          isLoaded: true
        });
      }
    );
  }

  getSelectedSize(pId) {
    const retVal = this.state.selectedSize.filter(item => item.itemId === pId);
    return retVal[0];
  }
  getPriceForSize(pId, selSize) {
    const retVal = this.state.menuItems.filter(item => item.productId === pId);
    const rVal2 = retVal[0].sizes.items.filter(item2 => item2.size === selSize);
    return rVal2[0].price;
  }
  getPrice(pId) {
    const retVal = this.state.selectedSize.filter(item => item.itemId === pId);
    return retVal[0].price.toFixed(2);
  }
  getItem(itemName, itemId, itemQuantity) {
    const sSize = this.getSelectedSize(itemId);
    const itemSize = sSize.size;
    const itemPrice = sSize.price;
    return {
      itemName: itemName,
      size: itemSize,
      price: itemPrice,
      quantity: itemQuantity
    };
  }

  onChangeSize(pid, event) {
    const selSize = event.target.value;
    var currSel = this.state.selectedSize;
    var newSel = [];
    for (var s in currSel) {
      var cItem = currSel[s];
      if (cItem.itemId === pid) {
        cItem = {
          itemId: pid,
          size: selSize,
          price: this.getPriceForSize(pid, selSize)
        };
      }
      newSel.push(cItem);
    }
    this.setState({
      selectedSize: newSel
    });
  }
  render() {
    return (
      <Fragment>
        <b>Add New Item</b>
        <Tabs defaultActiveKey="profile" id="uncontrolled-tab-example">
          <Tab eventKey="pizza" title="Pizza">
            <Container>
              {this.state.isLoaded
                ? this.state.menuItems
                    .filter(fItem => fItem.category === "PIZZA")
                    .map(menuItem => (
                      <Row key={menuItem.productId}>
                        <Col>
                          <img
                            src={`${this.imageLocation}${menuItem.productId}${".png"}`}
                            alt="Pizza"
                            width="100"
                            height="100"
                            className="position-relative img-fluid"
                          />
                        </Col>

                        <Col>
                          <b>{menuItem.productName}</b>
                          <br></br>
                          {menuItem.description}
                        </Col>
                        <Col>
                          <select
                            id="menuSize"
                            onChange={this.onChangeSize.bind(
                              this,
                              menuItem.productId
                            )}
                          >
                            {menuItem.sizes.items.map(sizeItem => (
                              <option key={sizeItem.size} value={sizeItem.size}>
                                {sizeItem.size}
                              </option>
                            ))}
                          </select>
                          <Button
                            onClick={() =>
                              this.props.onAddItem
                                ? this.props.onAddItem(
                                    this.getItem(
                                      `${menuItem.productName}`,
                                      `${menuItem.productId}`,
                                      1
                                    )
                                  )
                                : null
                            }
                          >
                            Add To Order
                          </Button>
                        </Col>
                        <Col>$ {this.getPrice(menuItem.productId)}</Col>
                      </Row>
                    ))
                : null}
            </Container>
          </Tab>
          <Tab eventKey="subs" title="Subs">
            <Container>
              {this.state.isLoaded
                ? this.state.menuItems
                    .filter(fItem => fItem.category === "SUB")
                    .map(menuItem => (
                      <Row key={menuItem.productId}>
                        <Col>
                          <img
                            src={`${this.imageLocation}${menuItem.productId}${".png"}`}
                            alt="Sub"
                            width="100"
                            height="100"
                            className="position-relative img-fluid"
                          />
                        </Col>

                        <Col>
                          <b>{menuItem.productName}</b>
                          <br></br>
                          {menuItem.description}
                        </Col>
                        <Col>
                          <select
                            id="menuSize"
                            onChange={this.onChangeSize.bind(
                              this,
                              menuItem.productId
                            )}
                          >
                            {menuItem.sizes.items.map(sizeItem => (
                              <option key={sizeItem.size} value={sizeItem.size}>
                                {sizeItem.size}
                              </option>
                            ))}
                          </select>
                          <Button
                            onClick={() =>
                              this.props.onAddItem
                                ? this.props.onAddItem(
                                    this.getItem(
                                      `${menuItem.productName}`,
                                      `${menuItem.productId}`,
                                      1
                                    )
                                  )
                                : null
                            }
                          >
                            Add To Order
                          </Button>
                        </Col>
                        <Col>$ {this.getPrice(menuItem.productId)}</Col>
                      </Row>
                    ))
                : null}
            </Container>
          </Tab>
          <Tab eventKey="sides" title="Sides">
            <Container>
              {this.state.isLoaded
                ? this.state.menuItems
                    .filter(fItem => fItem.category === "SIDE")
                    .map(menuItem => (
                      <Row key={menuItem.productId}>
                        <Col>
                          <img
                            src={`${this.imageLocation}${menuItem.productId}${".png"}`}
                            alt="Side"
                            width="100"
                            height="100"
                            className="position-relative img-fluid"
                          />
                        </Col>

                        <Col>
                          <b>{menuItem.productName}</b>
                          <br></br>
                          {menuItem.description}
                        </Col>
                        <Col>
                          <select
                            id="menuSize"
                            onChange={this.onChangeSize.bind(
                              this,
                              menuItem.productId
                            )}
                          >
                            {menuItem.sizes.items.map(sizeItem => (
                              <option key={sizeItem.size} value={sizeItem.size}>
                                {sizeItem.size}
                              </option>
                            ))}
                          </select>
                          <Button
                            onClick={() =>
                              this.props.onAddItem
                                ? this.props.onAddItem(
                                    this.getItem(
                                      `${menuItem.productName}`,
                                      `${menuItem.productId}`,
                                      1
                                    )
                                  )
                                : null
                            }
                          >
                            Add To Order
                          </Button>
                        </Col>
                        <Col>$ {this.getPrice(menuItem.productId)}</Col>
                      </Row>
                    ))
                : null}
            </Container>
          </Tab>
        </Tabs>
      </Fragment>
    );
  }
}

export default MenuItem;
```

Then, we need to add the menu to our `App.js` file. Replace the contents of
`App.js` with this and save `App.js`:

```js
import React, { Fragment, Component } from "react";
import "./App.css";
import { Container, Row, Col } from "reactstrap";
import Header from "./components/header";
import SideCard from "./components/sideCard";
import MenuItem from "./components/menu";
import Amplify, { Auth, Hub } from "aws-amplify";
import { Authenticator } from "aws-amplify-react";
import awsconfig from "./aws-exports";

Amplify.configure(awsconfig);

const signUpConfig = {
  header: "Welcome!",
  signUpFields: [
    {
      label: "First Name",
      key: "given_name",
      placeholder: "First Name",
      required: true,
      displayOrder: 5
    },
    {
      label: "Last Name",
      key: "family_name",
      placeholder: "Last Name",
      required: true,
      displayOrder: 6
    },
    {
      label: "Address",
      key: "address",
      placeholder: "Address",
      required: true,
      displayOrder: 7
    }
  ]
};

class App extends Component {
  state = {
    showType: "",
    loggedIn: false,
    currentUser: null
  };

  loadCurrentUser() {
    Auth.currentAuthenticatedUser().then(userInfo => {
      this.setState({
        loggedIn: true,
        currentUser: userInfo.username,
        currentUserData: userInfo
      });
    });
  }
  componentDidMount = () => {
    Hub.listen("auth", ({ payload: { event, data } }) => {
      switch (event) {
        case "signIn":
          this.setState({
            currentUser: data.username,
            currentUserData: data,
            loggedIn: true
          });
          break;
        case "signOut":
          this.setState({
            currentUser: null,
            loggedIn: false
          });
          break;
        default:
          break;
      }
    });
    this.loadCurrentUser();
  };

  handleLogin = () => {
    this.setState({
      showType: "login"
    });
  };

  handleLogout = () => {
    this.setState({
      showType: "login"
    });
  };

  handleOrder = () => {
    this.setState({
      showType: "menu"
    });
  };

  render() {
    return (
      <Fragment>
        <Header
          onHandleLogin={this.handleLogin}
          onHandleLogout={this.handleLogout}
          loggedIn={this.state.loggedIn}
          userName={this.state.currentUser}
          onHandleOrder={this.handleOrder}
        />
        <div className="my-5 py-5">
          <Container className="px-0">
            <Row
              noGutters
              className="pt-2 pt-md-5 w-100 px-4 px-xl-0 position-relative"
            >
              <Col
                xs={{ order: 2 }}
                md={{ size: 4, order: 1 }}
                tag="aside"
                className="pb-5 mb-5 pb-md-0 mb-md-0 mx-auto mx-md-0"
              >
                <SideCard />
              </Col>

              <Col
                xs={{ order: 1 }}
                md={{ size: 7, offset: 1 }}
                tag="section"
                className="py-5 mb-5 py-md-0 mb-md-0"
              >
                {this.state.showType === "" ? "This is the main content" : null}
                {this.state.showType === "login" ? (
                  <Authenticator signUpConfig={signUpConfig} />
                ) : null}
                {this.state.showType === "menu" ? (<MenuItem onAddItem={this.handleAddItem}></MenuItem>) : null}
              </Col>
            </Row>
          </Container>
        </div>
      </Fragment>
    );
  }
}

export default App;
```

This new code basically hooked up the menu to our Menu button: – `<MenuItem onAddItem={this.handleAddItem}></MenuItem>`

Now, we can return to our app and when we click the Menu link, we can you view our Pizza Menu:

If you do not see the menu of items, make sure that you have logged in!

Next, update App.js file to handle the adding of items to our cart. Replace App.js with the following code and save the App.js file:

```js
import React, { Fragment, Component } from "react";
import "./App.css";
import { Container, Row, Col, Button } from "reactstrap";
import Header from "./components/header";
import SideCard from "./components/sideCard";
import MenuItem from "./components/menu";
import OrderHistory from "./components/orders";
import Amplify, {Auth, Hub, Cache, API, graphqlOperation} from "aws-amplify";
import { Authenticator } from "aws-amplify-react";
import { createOrder, createItem, updateOrder } from "./graphql/mutations";
import awsconfig from "./aws-exports";

Amplify.configure(awsconfig);

const signUpConfig = {
  header: "Welcome!",
  signUpFields: [
    {
      label: "First Name",
      key: "given_name",
      placeholder: "First Name",
      required: true,
      displayOrder: 5
    },
    {
      label: "Last Name",
      key: "family_name",
      placeholder: "Last Name",
      required: true,
      displayOrder: 6
    },
    {
      label: "Address",
      key: "address",
      placeholder: "Address",
      required: true,
      displayOrder: 7
    }
  ]
};

class App extends Component {
  state = {
    showType: "",
    loggedIn: false,
    currentUser: null
  };

  listProductsWithVariant = `query ListProducts(
    $filter: ModelProductFilterInput
    $limit: Int
    $nextToken: String
  ) {
    listProducts(filter: $filter, limit: $limit, nextToken: $nextToken) {
      items {
        id
        productId
        productName
        category
        description
        defaultPrice
        sizes {
            items {
              price
              size
            }
          }
      }
      nextToken
    }
  }
  `;

  async loadExistingOrder(orderId) {
    const getOrderWithItems = `query GetOrder($id: ID!) {
      getOrder(id: $id) {
        id
        name
        user
        phone
        email
        orderDate
        orderTotal
        deliveryType
        deliveryDate
        status
        items {
          items {
            id
            itemName
            comments
            quantity
            size
            unitPrice
            totalPrice
          }
          nextToken
        }
      }
    }
    `;
    // Now we want to update the state with the new order data
    const orderInput = {
      id: orderId
    };
    const getOrderResult = await API.graphql(
      graphqlOperation(getOrderWithItems, orderInput)
    );
    this.setState({
      currentOrder: getOrderResult.data.getOrder
    });
  }

  createNewItem = async itemInput => {
    const newItem = await API.graphql(
      graphqlOperation(createItem, {
        input: itemInput
      })
    );
    return newItem;
  };

  createNewOrder = async orderInput => {
    const newOrder = await API.graphql(
      graphqlOperation(createOrder, {
        input: orderInput
      })
    );
    return newOrder;
  };

  appendLeadingZeroes = n => {
    if (n <= 9) {
      return "0" + n;
    }
    return n;
  };

  createOrderName(today) {
    return (
      today.getFullYear() +
      "-" +
      this.appendLeadingZeroes(today.getMonth() + 1) +
      "-" +
      this.appendLeadingZeroes(today.getDate())
    );
  }

  getOrderDate(today) {
    return (
      today.getFullYear() +
      "-" +
      this.appendLeadingZeroes(today.getMonth() + 1) +
      "-" +
      this.appendLeadingZeroes(today.getDate()) +
      "T" +
      this.appendLeadingZeroes(today.getHours()) +
      ":" +
      this.appendLeadingZeroes(today.getMinutes()) +
      ":" +
      this.appendLeadingZeroes(today.getSeconds()) +
      "-05:00:00"
    );
  }

  async createNewOrderConstruct() {
    var today = new Date();
    var orderName = this.createOrderName(today);
    var orderDate = this.getOrderDate(today);

    const orderInput = {
      name: "ORDER: " + orderName,
      user: this.state.currentUser,
      phone: this.state.currentUserData.attributes.phone_number,
      email: this.state.currentUserData.attributes.email,
      orderDate: orderDate,
      orderTotal: this.getTotal(this.state.currentOrder),
      deliveryType: "Carryout",
      deliveryDate: orderDate,
      status: "IN PROGRESS"
    };

    const newOrder = await this.createNewOrder(orderInput);
    return newOrder;
  }
  handleAddItem = async item => {
    var checkOrder = this.state.currentOrder;
    if (!checkOrder) {
      // Create new order
      //var cUser = await Auth.currentAuthenticatedUser();
      var today = new Date();
      const expiration = new Date(today.getTime() + 60 * 60000);
      var newOrder = await this.createNewOrderConstruct();
      Cache.setItem("currentOrder", newOrder.data.createOrder.id, {
        priority: 3,
        expires: expiration.getTime()
      });
      checkOrder = newOrder.data.createOrder;
    }

    var currentOrderId = checkOrder.id;

    const totalPrice = item.quantity * item.price;
    const itemInput = {
      itemName: item.itemName,
      comments: "No Comments",
      quantity: item.quantity,
      size: item.size,
      unitPrice: item.price,
      totalPrice: totalPrice,
      itemOrderId: currentOrderId
    };
    await this.createNewItem(itemInput);
    this.loadExistingOrder(currentOrderId);
  };

  loadCurrentUser() {
    Auth.currentAuthenticatedUser().then(userInfo => {
      this.setState({
        loggedIn: true,
        currentUser: userInfo.username,
        currentUserData: userInfo
      });
    });
  }

  getPriceForSize(pId, selSize) {
    const retVal = this.state.menuItems.filter(item => item.productId === pId);
    const rVal2 = retVal[0].sizes.items.filter(
      item2 => item2.size.toUpperCase() === selSize.toUpperCase()
    );
    return rVal2[0].price;
  }

  isLoggedIn = async () => {
    return await Auth.currentAuthenticatedUser()
      .then(() => {
        return true;
      })
      .catch(() => {
        return false;
      });
  };

  getCurrentUser = async () => {
    const user = await Auth.currentAuthenticatedUser();
    return user;
  };

  getTotal = items => {
    var totalPrice = 0;
    for (var i in items) {
      var qty = items[i]["quantity"];
      var price = items[i]["unitPrice"];
      var qtyPrice = qty * price;
      totalPrice += qtyPrice;
    }
    return totalPrice.toFixed(2);
  };

  createNewOrderConstructSync = () => {
    var today = new Date();
    var orderName = this.createOrderName(today);
    var orderDate = this.getOrderDate(today);

    const orderInput = {
      name: "ORDER: " + orderName,
      user: this.state.currentUser,
      phone: this.state.currentUserData.attributes.phone_number,
      email: this.state.currentUserData.attributes.email,
      orderDate: orderDate,
      orderTotal: this.getTotal(this.state.currentOrder),
      deliveryType: "Carryout",
      deliveryDate: orderDate,
      status: "IN PROGRESS"
    };

    this.createNewOrder(orderInput)
      .then(newOrder => {
        return newOrder;
      })
      .catch(err => {
        console.log(err);
      });
  };

  createNewItemSync = itemInput => {
    API.graphql(
      graphqlOperation(createItem, {
        input: itemInput
      })
    ).then(newItem => {
      return newItem;
    });
  };

  getItems = cOrder => {
    if (cOrder && cOrder.items) {
      return cOrder.items.items;
    } else {
      return null;
    }
  };

  completeOrder = () => {
    this.setState({ showType: "orderComplete" });
    const orderInput = {
      id: this.state.currentOrder.id,
      name: this.state.currentOrder.name,
      user: this.state.currentUser,
      phone: this.state.currentOrder.phone,
      email: this.state.currentOrder.email,
      orderDate: this.state.currentOrder.orderDate,
      orderTotal: this.getTotal(this.state.currentOrder.items.items),
      deliveryType: "Carryout",
      deliveryDate: this.state.currentOrder.deliveryDate,
      status: "COMPLETE"
    };

    API.graphql(
      graphqlOperation(updateOrder, {
        input: orderInput
      })
    ).then(result => {
      this.setState({
        currentOrder: null
      });
      Cache.removeItem("currentOrder");
    });
  };

  componentDidMount = () => {
    Hub.listen("auth", ({ payload: { event, data } }) => {
      switch (event) {
        case "signIn":
          this.setState({
            currentUser: data.username,
            currentUserData: data,
            loggedIn: true
          });
          break;
        case "signOut":
          this.setState({
            currentUser: null,
            loggedIn: false
          });
          break;
        default:
          break;
      }
    });
    this.loadCurrentUser();

    var currentOrderId = null;
    var checkOrder = this.state.currentOrder;
    if (checkOrder) currentOrderId = checkOrder.id;
    else currentOrderId = Cache.getItem("currentOrder");
    if (currentOrderId) {
      this.loadExistingOrder(currentOrderId);
    }

    // Get menu items
    API.graphql(graphqlOperation(this.listProductsWithVariant)).then(result => {
      this.setState({
        menuItems: result.data.listProducts.items
      });
    });

  };

  handleLogin = () => {
    this.setState({
      showType: "login"
    });
  };

  handleLogout = () => {
    this.setState({
      showType: "login"
    });
  };

  handleOrder = () => {
    this.setState({
      showType: "menu"
    });
  };

  handleHistory = () => {
    this.setState({
      showType: "orders"
    });
  };

  handleCheckout = () => {
    this.setState({
      showType: "checkout"
    });
  };

  render() {
    return (
      <Fragment>
        <Header
          onHandleLogin={this.handleLogin}
          onHandleLogout={this.handleLogout}
          onHandleHistory={this.handleHistory}
          loggedIn={this.state.loggedIn}
          userName={this.state.currentUser}
          onHandleOrder={this.handleOrder}
        />
        <div className="my-5 py-5">
          <Container className="px-0">
            <Row
              noGutters
              className="pt-2 pt-md-5 w-100 px-4 px-xl-0 position-relative"
            >
              <Col
                xs={{ order: 2 }}
                md={{ size: 4, order: 1 }}
                tag="aside"
                className="pb-5 mb-5 pb-md-0 mb-md-0 mx-auto mx-md-0"
              >
                <SideCard currentOrder={this.state.currentOrder} onHandleCheckout={this.handleCheckout}/>
              </Col>

              <Col
                xs={{ order: 1 }}
                md={{ size: 7, offset: 1 }}
                tag="section"
                className="py-5 mb-5 py-md-0 mb-md-0"
              >
                {this.state.showType === "" ? "This is the main content" : null}
                {this.state.showType === "login" ? (
                  <Authenticator signUpConfig={signUpConfig} />
                ) : null}
                {this.state.showType === "menu" ? (<MenuItem onAddItem={this.handleAddItem}></MenuItem>) : null}
                {this.state.showType === "orders" ? (
                  <OrderHistory userName={this.state.currentUser} />
                ) : null}
                {this.state.showType === "checkout" ? (
                  <Fragment>
                    <Container>
                      <Row className="font-weight-bold">
                        <Col>Item Name</Col>
                        <Col>Options</Col>
                        <Col>Price</Col>
                      </Row>
                      {this.getItems(this.state.currentOrder)
                        ? this.getItems(this.state.currentOrder).map(
                            orderInfo => (
                              <Row key={orderInfo.id}>
                                <Col>{orderInfo.itemName}</Col>
                                <Col>Qty: {orderInfo.quantity}</Col>
                                <Col>{orderInfo.totalPrice}</Col>
                              </Row>
                            )
                          )
                        : null}
                      <Row>
                        <Col>TOTAL</Col>
                        <Col></Col>
                        <Col>
                          $
                          {this.getTotal(
                            this.getItems(this.state.currentOrder)
                          )}
                        </Col>
                      </Row>
                    </Container>
                    <Button onClick={this.completeOrder}>Complete Order</Button>
                  </Fragment>
                ) : null}
                {this.state.showType === "orderComplete" ? (
                  <div>Thank you for your order!</div>
                ) : null}

              </Col>
            </Row>
          </Container>
        </div>
      </Fragment>
    );
  }
}

export default App;
```

The code above accomplishes the following:

* Add the Cache and graphql imports – `import { createOrder, createItem } from "./graphql/mutations"`;
* Adds handler to respond to the "Add To Order" menu button – `handleAddItem = async item => {`
* Creates and caches the order in state

Next, add the following code to `components/orders.jsx` and save the file `orders.jsx`:

```js
import React, { Component, Fragment } from "react";
import { API, graphqlOperation } from "aws-amplify";
import { listOrders } from "../graphql/queries";
import { Container, Row, Col } from "reactstrap";

class OrderHistory extends Component {
  state = {
    orderData: null
  };

  componentDidMount() {
    const userId = this.props.userName;
    API.graphql(
      graphqlOperation(listOrders, {
        limit: 30,
        filter: {
          user: { eq: userId }
        }
      })
    ).then(result => {
      this.setState({
        orderData: result.data.listOrders.items
      });
    });
  }

  getDate(dateStr) {
    return dateStr.substring(0, 10);
  }
  render() {
    return (
      <Fragment>
        <b>Your Order History</b>
        <Container>
          <Row className="font-weight-bold">
            <Col>Order Date</Col>
            <Col>Order Status</Col>
            <Col>Order Total</Col>
          </Row>
          {this.state.orderData
            ? this.state.orderData.map(orderInfo => (
                <Row key={orderInfo.id}>
                  <Col>{this.getDate(orderInfo.orderDate)}</Col>
                  <Col>{orderInfo.status}</Col>
                  <Col>$ {orderInfo.orderTotal}</Col>
                </Row>
              ))
            : "NO CURRENT ORDERS"}
        </Container>
      </Fragment>
    );
  }
}

export default OrderHistory;
```

The above code displays order history for the user.

Next, update `components/sideCard.jsx` file to display our cart items when the
order changes. Save the file `sideCard.jsx`:

```js

import React, { Component, Fragment } from "react";
import {
  Button,
  UncontrolledAlert,
  Card,
  CardBody,
  CardTitle,
  CardSubtitle,
  Container,
  Row,
  Col
} from "reactstrap";

class SideCard extends Component {
  state = {};

  getTotal = items => {
    var totalPrice = 0;
    for (var i in items) {
      var qty = items[i]["quantity"];
      var price = items[i]["unitPrice"];
      var qtyPrice = qty * price;
      totalPrice += qtyPrice;
    }
    return totalPrice.toFixed(2);
  };

  getItems = cOrder => {
    if (cOrder && cOrder.items) {
      return cOrder.items.items;
    } else {
      return null;
    }
  };


  render() {
    const localItems = this.getItems(this.props.currentOrder);
    return (
      <Fragment>
        <UncontrolledAlert color="primary" className="d-none d-lg-block">
          <strong>Recommended for you!</strong>
          <br />
          <Fragment>
            <b>Product Name</b>
            <br></br>
            This is a placeholder for a product description
            <br></br>
            <Button color="success">Add this to Order</Button>
          </Fragment>
        </UncontrolledAlert>

        <Card>
          <CardBody>
            <CardTitle className="h3 mb-2 pt-2 font-weight-bold text-secondary">
              Your Current Cart
            </CardTitle>
            <CardSubtitle
              className="text-secondary mb-2 font-weight-light text-uppercase"
              style={{ fontSize: "0.8rem" }}
            >
              Total: ${this.getTotal(localItems)}
            </CardSubtitle>
            <div
              className="text-secondary mb-4"
              style={{ fontSize: "0.75rem" }}
            >
              <Container>
                <Row className="font-weight-bold">
                  <Col>Item Name</Col>
                  <Col>Options</Col>
                  <Col>Price</Col>
                </Row>
                {localItems
                  ? localItems.map(orderInfo => (
                      <Row key={orderInfo.id}>
                        <Col>{orderInfo.itemName}</Col>
                        <Col>Qty: {orderInfo.quantity}</Col>
                        <Col>{orderInfo.totalPrice}</Col>
                      </Row>
                    ))
                  : null}
              </Container>
            </div>
            <Button
              color="success"
              className="font-weight-bold"
              onClick={() =>
                this.props.onHandleCheckout
                  ? this.props.onHandleCheckout()
                  : null
              }
            >
              Checkout
            </Button>
          </CardBody>
        </Card>


        <br />
        <Button
          color="info"
          onClick={() =>
            this.props.onHandleChat ? this.props.onHandleChat() : null
          }
        >
          Chat to Order!
        </Button>
      </Fragment>
    );
  }
}

export default SideCard;
```

This code receives the current order information and displays each item in the cart, and creates the total.

Finally, return to the preview application, open the menu, and add a few items to the order.

Now, we have a fully functioning pizza ordering application! But let’s add some intelligent features!


```
^CTeamRole:~/environment/andy-pizza-shop (master) $ amplify status

Current Environment: dev

| Category | Resource name         | Operation | Provider plugin   |
| -------- | --------------------- | --------- | ----------------- |
| Auth     | andypizzashop67f708c6 | No Change | awscloudformation |
| Api      | andypizzashop         | No Change | awscloudformation |

GraphQL endpoint: https://rgtj72cbafelhgyxkslln57r7y.appsync-api.us-west-2.amazonaws.com/graphql
```
