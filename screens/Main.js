
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity, AsyncStorage,Image} from 'react-native';
import {Navigation} from 'react-native-navigation';
import {styles} from '../styles.js'
import {QuizButt, Butt} from '../components/buttons.js'


type Props = {};
export default class Main extends Component<Props> {

  constructor(){
    super()
  
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

    // ActivityIndicator narazie niet

    // if(this.state.isLoading){
    //   return(
    //     <View style={{flex: 1, padding: 20}}>
    //       <ActivityIndicator/>
    //     </View>
    //   )
    // }

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
          <Text style={styles.title}>Witamy w aplikacji ForeMe</Text>
          <Text style={styles.title}>Kliknij przycisk poniżej aby wyświetlić</Text>

          <Butt title={'Wyniki pomiarów'} func={()=>this.openScreen('Results')}>
          </Butt>
        </View>

      </View>
    );

  }
}
