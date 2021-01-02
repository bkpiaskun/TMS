import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity, AsyncStorage,Image} from 'react-native';
import {Navigation} from 'react-native-navigation';
import {styles} from '../styles.js'
import {QuizButt, Butt} from '../components/buttons.js'
import ActionButton from 'react-native-circular-action-menu';
import Icon from 'react-native-vector-icons/FontAwesome';
import * as Animatable from 'react-native-animatable';

type Props = {};
export default class Main extends Component<Props> {

  constructor(){
    super()
    this.state={
      description:"Witamy w aplikacji ForeMe"
    }
  }

  openScreen(screenName){
    Navigation.push(this.props.componentId,{
      component: {
        name:screenName
      }
    })
  }

  _retrieveData = async () => {
    try {
      const value = await AsyncStorage.getItem('Welcome');
      if (value !== null) {
        /* Don't open anything*/
      }else{
        // this.openScreen('Welcome')  <-- this crashes the app
        setTimeout(()=>this.openScreen('Welcome'),10000)
      }
    } catch (error) {
      alert(error);
    }
}

  render() {

    {this._retrieveData()}

    return (
      <View style={styles.container}>
        <View style={styles.topBoi}>
          <Text style={styles.headerText}>Aplikacja ForeMe</Text>
        </View>
        <View style={styles.splashHolder}>

          <Image
            style={styles.logo}
            source={require('../img/logo.png')}
           />
          {/* <Text style={styles.title}>Witamy w aplikacji ForeMe</Text>
          <Text style={styles.title}>Kliknij przycisk poniżej aby wyświetlić</Text> */}

          <Animatable.Text
            style={styles.title}
            animation="fadeIn"
            delay={500}
          >
            Witamy w aplikacji ForeMe
          </Animatable.Text>
          <Animatable.Text
            style={styles.title}
            animation="fadeIn"
            delay={2500}
          >
            Kliknij przycisk aby rozpocząć
          </Animatable.Text>

          <ActionButton 
              buttonColor="#eb5000" 
              btnOutRange="#eb5000"
              radius={80}
          >
            <ActionButton.Item buttonColor='#170a45' onPress={()=>this.openScreen('Results')} >
                <Icon name="thermometer-empty" style={styles.actionButtonItemsIcons}></Icon>
            </ActionButton.Item>
            <ActionButton.Item buttonColor='#170a45' onPress={()=>this.openScreen('Weather')}>
                <Icon name="building" style={styles.actionButtonItemsIcons}></Icon>
            </ActionButton.Item>
            <ActionButton.Item buttonColor='#170a45' onPress={()=>this.openScreen('Authors')}>
                <Icon name="users" style={styles.actionButtonItemsIcons}></Icon>
            </ActionButton.Item>
          </ActionButton>
        </View>

      </View>
    );

  }
}
