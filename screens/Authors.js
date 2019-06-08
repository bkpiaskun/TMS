import React, {Component} from 'react';
import {Platform, StyleSheet, Text, View, TouchableOpacity} from 'react-native';
import {styles} from '../styles.js'
import {Avatar, Tooltip} from 'react-native-elements'
type Props = {};

export default class Authors extends Component<Props> {

  constructor() {
      super();
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
            />
            
            <Text style={{marginLeft:40, fontSize:20, fontWeight:'bold', color:'#FFFFFF'}}> Bartłomiej Kluska</Text>
          </View>
          <View style={[styles.forEachAuthor, {alignSelf:'flex-end',flexDirection:'row-reverse'}]}>
            <Avatar
                  rounded
                  size="xlarge"
                  source={{uri:'https://github.com/Kilian666.png'}}
            />
            
            <Text style={{marginRight:40, fontSize:20, fontWeight:'bold', color:'#FFFFFF'}}> Karol Kilian</Text>
          </View>
          <View style={styles.forEachAuthor}>
            <Avatar
                rounded
                size="xlarge"
                source={{uri:'https://github.com/piatek29535.png'}}
            />

            <Text style={{marginLeft:40, fontSize:20, fontWeight:'bold', color:'#FFFFFF'}}> Adam Piątek </Text>
          </View>
            
        </View> 
      </View>
    );
  }
}
