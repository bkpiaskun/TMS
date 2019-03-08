
import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, ScrollView, TouchableOpacity, AsyncStorage, ActivityIndicator,Image} from 'react-native';
import {Navigation} from 'react-native-navigation';
import {styles} from '../styles.js'
import {QuizButt, Butt} from '../components/buttons.js'


type Props = {};
export default class Main extends Component<Props> {

  constructor(){
    super()
    this.state = {
      isLoading: true,
      jsonFromServer:" ",
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

componentDidMount(){
    fetch('https://pwsz-quiz-api.herokuapp.com/api/tests')
      .then((response) => response.json())
      .then((responseJson) => {
          this.setState({
            isLoading: false,
              jsonFromServer: responseJson,
          })
      })
      .catch((error) => {
          console.error(error)
      });
  }

 

  render() {

    {this._retrieveData()}

    if(this.state.isLoading){
      return(
        <View style={{flex: 1, padding: 20}}>
          <ActivityIndicator/>
        </View>
      )
    }

    return (
      <View style={styles.container}>
        <View style={styles.topBoi}>
          <Text style={styles.headerText}>ForeMe</Text>
        </View>
        <ScrollView vertical={true} style={styles.scrollContainer}>
        <View style={styles.splashHolder}>

          <Image
            style={styles.logo}
            source={require('../img/pp.png')}
           />
          <Text style={styles.title}>Witamy w naszej aplikacji</Text>

        </View>
          <Butt title={'Wyniki pomiarów'} func={()=>this.openScreen('Results')}>
          </Butt>
        </ScrollView>
      </View>
    );

  }
}
