
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableWithoutFeedback} from 'react-native';
import {Navigation} from 'react-native-navigation';
import LottieView from 'lottie-react-native';
import {styles} from '../styles.js'
// import console = require('console');

type Props = {};
let randomAnimation = [require('../animations/loading1.json'),require('../animations/loading2.json'),require('../animations/loading3.json'),require('../animations/loading4.json')];

export default class Splash extends Component<Props> {

  constructor(){
    super();
    this.state = {
      random: Math.floor((Math.random() * 4))
    }
  }

  goHome(screenName){
    Navigation.setStackRoot('AppStack',{
      component: {
        name:screenName,
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
        source={randomAnimation[this.state.random]}
        loop={false}
        onAnimationFinish={() => this.goHome("Main")}
      />
    </View>
    );
  }
}
