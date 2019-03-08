
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableWithoutFeedback} from 'react-native';
import {Navigation} from 'react-native-navigation';
import LottieView from 'lottie-react-native';
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

  componentDidMount(){
    this.animation.play();
    setTimeout(()=>this.goHome('Main'),4000)
  }
  
  render() {
    return (

      <LottieView
        ref={animation => {
          this.animation = animation;
        }}
        source={require('../animations/loading3.json')}
        style={{backgroundColor:'rgb(229,229,255)'}}
      />

    );
  }
}
