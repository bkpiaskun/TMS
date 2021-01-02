
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, ScrollView, TouchableOpacity, Image, TouchableWithoutFeedback, AsyncStorage} from 'react-native';

import {Navigation} from 'react-native-navigation';
import {styles} from '../styles.js'

type Props = {};
export default class Welcome extends Component<Props> {

  goHome(screenName){
    Navigation.setStackRoot('AppStack',{
      component: {
        name:screenName
      }
    })
  }

  _storeData = async () => {
  try {
    await AsyncStorage.setItem('Welcome', 'Seen');
  } catch (error) {
    alert(error);
  }
}

  render() {
{this._storeData()}
    return (
      <TouchableWithoutFeedback onPress={()=>this.goHome('Main')}style={[styles.splash, styles.comntainer]}>

        <View style={styles.splashHolder}>

        <Image
          style={styles.logo}
          source={require('../img/logo.png')}
        />
          <Text style={styles.title}></Text>

        </View>

      </TouchableWithoutFeedback>
    );
  }
}
