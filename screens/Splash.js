
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
  }
  
  render() {
    return (
    <View style={{backgroundColor:'#ff7c38',flex:1}}>
      <LottieView
        ref={animation => {
          this.animation = animation;
        }}
        source={require('../animations/loading3.json')}
        loop={false}
        onAnimationFinish={() => this.goHome("Main")}
      />
    </View>
    );
  }
}
