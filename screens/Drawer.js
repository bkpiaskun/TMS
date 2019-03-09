
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, ScrollView, TouchableOpacity, Image} from 'react-native';
import {Navigation} from 'react-native-navigation';
import {styles} from '../styles.js'
import {Butt} from '../components/buttons.js'

type Props = {};
export default class Drawer extends Component<Props> {

  goToScreen(screenName){
    Navigation.setStackRoot('AppStack',{
      component: {
        name:screenName
      }
    })
  }

  openScreen(screenName){
    Navigation.push('AppStack',{
      component: {
        name:screenName
      }
    })
  }

  render() {
    return (
      <View style={styles.drawerMainContainer}>
        <View style={styles.drawerHeader}>
          <Image
            style={styles.drawerLogo}
            source={require('../img/drawerIco.png')}
            />
          <Text style={styles.drawerHeaderText}>Szybki dostęp</Text>
          
        </View>
        <View style={styles.drawerButtons}>

          <TouchableOpacity onPress = {()=>this.goToScreen("Main")} style={styles.drawerButton}>
            <Text style={styles.drawerButtonText}>Ekran główny</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress = {()=>this.goToScreen("Results")} style={styles.drawerButton}>
            <Text style={styles.drawerButtonText}>Wyniki pomiarów</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.drawerButton}>
            <Text style={styles.drawerButtonText}>Test Button</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.drawerButton}>
            <Text style={styles.drawerButtonText}>Test Button 2</Text>
          </TouchableOpacity>

        </View>
      </View>
    );
  }
}
