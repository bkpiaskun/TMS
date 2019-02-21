
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, ScrollView, TouchableOpacity, Image, TouchableWithoutFeedback} from 'react-native';

import {Navigation} from 'react-native-navigation';
import {styles} from '../styles.js'

type Props = {};
export default class Splash extends Component<Props> {

  goHome(screenName){
    Navigation.setStackRoot('AppStack',{
      component: {
        name:screenName
      }
    })
  }

  render() {
    setTimeout(()=>this.goHome('Main'),1234)
    return (
      <TouchableWithoutFeedback onPress={()=>this.goHome('Main')}style={[styles.splash, styles.comntainer]}>

        <View style={styles.splashHolder}>

          <Text style={styles.title}></Text>
          <Image
          style={styles.logo}
          source={require('../img/pp.png')}
          />

        </View>

      </TouchableWithoutFeedback>
    );
  }
}
