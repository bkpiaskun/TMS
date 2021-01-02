/** @format */

import {Navigation} from "react-native-navigation";
import Main from './screens/Main.js';
import Results from './screens/Results.js'
import Drawer from './screens/Drawer.js'
import Splash from './screens/Splash.js'
import Welcome from './screens/Welcome.js'
import Weather from './screens/Weather.js'
import Authors from './screens/Authors.js'


Navigation.registerComponent('Main', () => Main);
Navigation.registerComponent('Results', () => Results);
Navigation.registerComponent('Drawer', () => Drawer);
Navigation.registerComponent('Splash', () => Splash);
Navigation.registerComponent('Welcome', () => Welcome);
Navigation.registerComponent('Weather', () => Weather);
Navigation.registerComponent('Authors', () => Authors);


Navigation.events().registerAppLaunchedListener(() => {
  Navigation.setDefaultOptions({
    layout: {
      orientation: ['portrait']
    },
    topBar: {
      elevation: 0,
      visible: false,
      drawBehind: true,
      animate: false,
      buttonColor: 'white',
      title: {
        color: 'white',
        alignment: 'center'
      },
      background: {
        color: 'transparent'
      }
    },
  });
  Navigation.setRoot({
    root: {
      sideMenu: {
        left: {
          component: {
            id: 'drawerId',
            name: 'Drawer',
          }
        },
        center:{
          stack:{
            id: 'AppStack',
            children: [
              {
                component:{
                  name: "Splash",
                }
              }
            ]
          }
        }
      }
    }
  });
});
