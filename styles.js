import {StyleSheet} from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#F5FCFF',
    alignItems: 'stretch'
  },
  splash: {
    alignItems: 'center',
    alignContent: 'center',
    flex: 1,
    backgroundColor: '#ffd69e',
  },
  splashHolder:{
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1
  },
  logo:{
    width: 200,
    height: 200
  },
  scrollContainer: {
    backgroundColor: '#ffd69e',
  },
  title: {
    fontWeight: "bold",
    fontFamily: "SourceSansPro-Black",
    fontSize: 18
  },
  p: {
    fontSize: 14
  },
  topBoi: {
    alignItems: 'center',
    backgroundColor: '#ADFF2F',
    borderBottomColor: '#755934',
    borderBottomWidth: 2
  },
  headerText: {
    fontSize: 24,
    padding: 9,
    fontFamily: "SourceSansPro-Black",
  },
  chooseQuizButt: {
    margin: 16,
    padding: 12,
    borderColor: '#755934',
    borderWidth: 1,
    alignItems: 'center',
  },
  listView:{
  marginTop:20,
},

results:{
  borderWidth:2,
  borderStyle:'dashed',
  borderColor:'#FFFFFF',
  borderRadius:5,
  backgroundColor:"green",
  margin:5,
  padding:15,
},

resultText:{
  fontSize:15,
  fontFamily:"SourceSansPro-Black",
  letterSpacing:1

}

})
