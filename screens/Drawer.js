
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
      <View style={styles.container}>

        <View style={styles.topBoi}>
          <Text style={styles.headerText}>Main Menu</Text>
          <Image
            style={{width: 200, height: 200}}
            source={require('../img/pp.png')}
            />
        </View>

        <ScrollView vertical={true} style={styles.scrollContainer}>
          <View>

            <Butt title={'Home'} func={()=>this.goToScreen('Main')}>
            </Butt>
            
            <Butt title={'Wyniki pomiarów'} func={()=>this.openScreen('Results')}>
            </Butt>

          </View>
        </ScrollView>

      </View>
    );
  }
}
