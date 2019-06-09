import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity} from 'react-native';
import {styles} from '../styles.js'
import {Avatar, Tooltip} from 'react-native-elements'
import * as Animatable from 'react-native-animatable';

type Props = {};

export default class Authors extends Component<Props> {

  constructor() {
      super();
      this.state={
        author1Name:"",
        author2Name:"",
        author3Name:"",
        counterA1:0,
        counterA2:0,
        counterA3:0,
        actionA1:"fadeOut",
        actionA2:"fadeOut",
        actionA3:"fadeOut",

      }
  }

  render() {
    return (
      <View style={styles.container}>
        <View style={styles.topBoi}>
          <Text style={styles.headerText}>Autorzy aplikacji</Text>
        </View>
        <View style={styles.authorsView}> 
          
          <View style={styles.forEachAuthor}>
              <Avatar
                    rounded
                    size="xlarge"
                    source={{uri:'https://github.com/bkpiaskun.png'}}
                    onPress={() => {
                      this.setState({
                        counterA1:this.state.counterA1+1
                      })
                      if(this.state.counterA1%2===0){
                        this.setState({
                          author1Name:"Bartłomiej Kluska",
                          actionA1:"fadeIn"
                        })
                      }else{
                        this.setState({
                          actionA1:"fadeOut"
                        })
                      }
                    }}
              />
              <Animatable.Text 
                animation={this.state.actionA1} 
                direction="alternate"
                style={{marginLeft:30, fontSize:20, fontWeight:'bold', color:'#FFFFFF'}}
              >
                {this.state.author1Name}
              </Animatable.Text>
          </View>
          <View style={[styles.forEachAuthor, {alignSelf:'flex-end',flexDirection:'row-reverse'}]}>
            <Avatar
                  rounded
                  size="xlarge"
                  source={{uri:'https://github.com/Kilian666.png'}}
                  onPress={() => {
                    this.setState({
                      counterA2:this.state.counterA2+1
                    })
                    if(this.state.counterA2%2===0){
                      this.setState({
                        author2Name:"Karol Kilian",
                        actionA2:"fadeIn"
                      })
                    }else{
                      this.setState({
                        actionA2:"fadeOut"
                      })
                    }
                  }}
            />
            
            <Animatable.Text 
                animation={this.state.actionA2} 
                direction="alternate"
                style={{marginRight:50, fontSize:20, fontWeight:'bold', color:'#FFFFFF'}}
              >
                {this.state.author2Name}
            </Animatable.Text>
          </View>
          <View style={styles.forEachAuthor}>
            <Avatar
                rounded
                size="xlarge"
                source={{uri:'https://github.com/piatek29535.png'}}
                onPress={() => {
                  this.setState({
                    counterA3:this.state.counterA3+1
                  })
                  if(this.state.counterA3%2===0){
                    this.setState({
                      author3Name:"Adam Piątek",
                      actionA3:"fadeIn"
                    })
                  }else{
                    this.setState({
                      actionA3:"fadeOut"
                    })
                  }
                }}
            />

            <Animatable.Text 
                animation={this.state.actionA3} 
                direction="alternate"
                style={{marginLeft:40, fontSize:20, fontWeight:'bold', color:'#FFFFFF'}}
              >
                {this.state.author3Name}
            </Animatable.Text>
          </View>
            
        </View> 
      </View>
    );
  }
}
