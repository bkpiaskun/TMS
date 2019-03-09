import {StyleSheet} from 'react-native';

export const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    backgroundColor: '#FFFFFF',
    alignItems: 'stretch'
  },
  splash: {
    alignItems: 'center',
    alignContent: 'center',
    flex: 1,
    backgroundColor: '#ffd69e',
  },
  splashHolder:{
    flex: 7,
    backgroundColor: '#ff7c38',
    justifyContent:'center',
    alignItems:'center'
  },
  logo:{
    width:300,
    height:300,
    padding:20,
    resizeMode:'contain'
  },
  scrollContainer: {
    backgroundColor: '#71c9ce',
  },
  title: {
    fontWeight: "bold",
    fontFamily: "SourceSansPro-Black",
    fontWeight:'bold',
    color:'#FFFFFF',
  },
  p: {
    fontSize: 14
  },
  topBoi: {
    justifyContent:'center',
    alignItems: 'center',
    fontSize: 20,
    backgroundColor: '#e03e36',
    flex:1,
  },
  headerText: {
    fontSize: 24,
    padding: 9,
    color:"#FFFFFF",
    fontFamily: "SourceSansPro-Black",
  },
  chooseQuizButt: {
    margin: 16,
    padding: 12,
    width:300,
    borderColor: '#FFFFFF',
    backgroundColor:'#eb5000',
    borderWidth: 3,
    borderRadius: 20,
    alignItems:'center'
  },
  listView:{
    marginTop:20,
    backgroundColor:'blue',
    flex:7,
  },

results:{
  borderWidth:2,
  borderColor:'#700961',
  borderRadius:5,
  backgroundColor:"rgb(139, 152, 201)",
  margin:15,
  padding:15,
},

resultText:{
  color:'rgb(255,255,255)',
  fontSize:15,
  fontFamily:"SourceSansPro-Black",
  letterSpacing:1
}

})
