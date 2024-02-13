import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
   SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {


TextEditingController dayController= new TextEditingController();

TextEditingController monthController= new TextEditingController();

TextEditingController yearController= new TextEditingController();

List<String> monthList = ["1","2","3","4","5","6","7","8","9","10","11","12"];

List<String> dayList = ["10","11","12","13","14","15","16","`17","18","19","20","21"];

List<String> yearhList = ["1990","1991","1992","1993","1994","1995"
,"1996","1997","1999","2000","2001","2002","2003","2004","2005","2006","2007"];

bool displayMonthList = false;
bool displayDayList = false ; 
bool displayYearList = false ; 
 
String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  


  @override


  Widget build(BuildContext context) {
    return 
      
      Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          
          backgroundColor:Color.fromARGB(255, 228, 228, 226),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Text(
                        "خۆتۆمارکردن",
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "هەژماریک دروست بکە",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      )
                    ],
                  ),
                Container(height: 600,
                
                  child: ListView(

                      children: <Widget>[
                       
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "ناوی بەکارهێنەر",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor: Color.fromARGB(255, 207, 226, 233),
                                filled: true,
                                prefixIcon: const Icon(Icons.person)),
                          ),
                        
                        ),
                            
                            Center(
                              child: Container(
                                // width: double.infinity,
                                // height: double.infinity,
                                child:
                               Column( mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: SizedBox(
                                    height: 20,
                                  ),
                                ),
                                Row(children: [
                                  Column( 

                                    children: [
                                      Text("ڕۆژ"),
                                    _inputField("day"),
                                    displayDayList ? selectionField("Day" , dayController) : SizedBox()],
                                    ),
                                    SizedBox(width: 10,
                                    ),
                                     Column(children: [
                                      Text("مانگ"),
                                      _inputField("month"),
                                    displayMonthList ? selectionField("month" , monthController) : SizedBox()],
                                    ),  SizedBox( 
                                      width: 30,
                                    ),
                                     Column(children: [
                                      Text("ساڵ"),
                                      _inputField("Year"),
                                    displayYearList ? selectionField("Year", yearController) : SizedBox()],
                                    ),
                                    ],
                                    ),
                               
                              
                              ],
                              ),
                              
                              
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: TextField(
                            //     decoration: InputDecoration(
                            //     hintText: "تەمەن ",
                            //     border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(18),
                            //         borderSide: BorderSide.none),
                            //     fillColor: Color.fromARGB(255, 207, 226, 233),
                            //     filled: true,
                            //     prefixIcon: const Icon(Icons.timelapse)
                            //     ),

                            // ),

                            // ),
                             
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "ئیمەیڵ",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none),
                                fillColor:const Color.fromARGB(255, 207, 226, 233),
                                filled: true,
                                prefixIcon: const Icon(Icons.email)),
                          ),
                        ),
                          Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "وشەی نهێنی",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: const Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.password),
                            ),
                            obscureText: true,
                          ),
                        ),
                       
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "دووپات کردنەوەی وشەی نهێنی",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none),
                              fillColor: const Color.fromARGB(255, 207, 226, 233),
                              filled: true,
                              prefixIcon: const Icon(Icons.password),
                            ),
                            obscureText: true,
                          ),
                        ),
                   Container(
                    decoration: BoxDecoration(border: Border.all(
                      color: Color.fromARGB(255, 207, 226, 233),
                      width: 1 ,
                    ), borderRadius: BorderRadius.circular(15)
                    ),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8.0),
                       child: DropdownButton(
                        hint: const Text('ڕەگەز'),
                                       value: dropdownvalue,
                                       borderRadius: BorderRadius.circular(10),
                                       dropdownColor: Color.fromARGB(255, 207, 226, 233), 
                                       items: items.map((String items) {
                                         return DropdownMenuItem(
                                           value: items,
                                         child: Text(items),
                                         );
                                       }).toList(),
                                       onChanged: (String? newValue) {
                                         setState(() {
                                       dropdownvalue = newValue!;
                                         });
                                       }),
                     ),
                   ), 
                ///ragaz
                          
           Container(
                    decoration: BoxDecoration(border: Border.all(
                      color: Color.fromARGB(255, 207, 226, 233),
                      width: 1 ,
                    ), borderRadius: BorderRadius.circular(15)
                    ),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8.0),
                       child: DropdownButton(
                        hint: const Text('بەش'),
                                       value: dropdownvalue,
                                       borderRadius: BorderRadius.circular(10),
                                       dropdownColor: Color.fromARGB(255, 207, 226, 233),
                                        
                                       items: items.map((String items) {
                                         return DropdownMenuItem(
                                           value: items,
                                         child: Text(items),
                                         );
                                       }).toList(),
                                       onChanged: (String? newValue) {
                                         setState(() {
                                       dropdownvalue = newValue!;
                                       
                                         });
                                       }),
                     ),
                   ),

                Container(
                    decoration: BoxDecoration(border: Border.all(
                      color: Color.fromARGB(255, 207, 226, 233),
                      width: 1 ,
                    ), borderRadius: BorderRadius.circular(15)
                    ),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8.0),
                       child: DropdownButton(
                        hint: const Text('بەش'),
                                       value: dropdownvalue,
                                       borderRadius: BorderRadius.circular(10),
                                       dropdownColor: Color.fromARGB(255, 207, 226, 233),
                                        
                                       items: items.map((String items) {
                                         return DropdownMenuItem(
                                           value: items,
                                         child: Text(items),
                                         );
                                       }).toList(),
                                       onChanged: (String? newValue) {
                                         setState(() {
                                       dropdownvalue = newValue!;
                                       
                                         });
                                       }),
                     ),
                   ),
                     Container(
                    decoration: BoxDecoration(border: Border.all(
                      color: Color.fromARGB(255, 207, 226, 233),
                      width: 1 ,
                    ), borderRadius: BorderRadius.circular(15)
                    ),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 8.0),
                       child: DropdownButton(
                        hint: const Text('کۆلێژ'),
                                       value: dropdownvalue,
                                       borderRadius: BorderRadius.circular(10),
                                       dropdownColor: Color.fromARGB(255, 207, 226, 233),
                                        
                                       items: items.map((String items) {
                                         return DropdownMenuItem(
                                           value: items,
                                         child: Text(items),
                                         );
                                       }).toList(),
                                       onChanged: (String? newValue) {
                                         setState(() {
                                       dropdownvalue = newValue!;
                                       
                                         });
                                       }),
                     ),
                   ),
                        
                        
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //         hintText: "ئیمەیڵ",
                        //         border: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(18),
                        //             borderSide: BorderSide.none),
                        //         fillColor:const Color.fromARGB(255, 207, 226, 233),
                        //         filled: true,
                        //         prefixIcon: const Icon(Icons.email)),
                        //   ),
                        // ),
                        
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       hintText: "وشەی نهێنی",
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(18),
                        //           borderSide: BorderSide.none),
                        //       fillColor: const Color.fromARGB(255, 207, 226, 233),
                        //       filled: true,
                        //       prefixIcon: const Icon(Icons.password),
                        //     ),
                        //     obscureText: true,
                        //   ),
                        // ),
                       
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       hintText: "دووپات کردنەوەی وشەی نهێنی",
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(18),
                        //           borderSide: BorderSide.none),
                        //       fillColor: const Color.fromARGB(255, 207, 226, 233),
                        //       filled: true,
                        //       prefixIcon: const Icon(Icons.password),
                        //     ),
                        //     obscureText: true,
                        //   ),
                        // ),
                      ],
                    ),
                ),
                  Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "خۆتۆمارکردن",
                          style: TextStyle(fontSize: 20 , color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:Color.fromARGB(255, 29, 109, 129),
                        ),
                      )),
                  const Center(child: Text("یان")),
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Color.fromARGB(255, 255, 255, 252),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 29, 109, 129),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                          
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/login_signup/google.png'),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Text(
                            "چونە ژورەوە لەگەڵ گۆگڵ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "پێشتر خۆت تۆمار کردووە؟",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0) , fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            "چونە ژوورەوەش",
                            style: TextStyle(
                                color:Color.fromARGB(255, 197, 38, 38)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
  
  }
  Widget _inputField(String type){
return  Container(width: 110,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black),
                                    color: Colors.white ,
                                    borderRadius: BorderRadius.circular(6)
                                    ),
                                child: TextField(
                                  controller: controller ,

                                  decoration: InputDecoration(
                                     border:
                                   InputBorder.none ,
                                   suffixIcon: GestureDetector(
                                    onTap: (){setState(() {
                                      switch (type) {
                                        case "Day":
                                           displayDayList =!displayDayList;
                                           break ;
                                        case "month":
                                         displayMonthList =!displayMonthList;
                                           break ;
                                        case "Year":
                                         displayYearList =!displayYearList;
                                           break ;
                                          
                                         
                                     
                                      }
                                   
                                      
                                    });},
                                    child: Icon(Icons.arrow_downward)
                                   ),
                                  ),
                                ),
                                );

  }
  Widget selectionField(String type  , TextEditingController controller){
    return 
                            Container(
                              height: 200, 
                              width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                             color: Colors.white,
                             boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3),
                             spreadRadius: 1,
                             blurRadius: 3,
                             offset: Offset(0, 1),
                             ),
                             ],
                            ),
                            child: ListView.builder(
                              itemCount:type=="Day"
                                ? dayList.length
                              :type "month"
                              ? monthList.length :
                              yearhList.length,
                               itemBuilder: ((context ,Index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                  switch (type) {
                                    case "day":
                                      controller.text = dayList[Index];
                                      break;
                                        case "Month":
                                      controller.text = monthList[Index];
                                      break;
                                        case "Year":
                                      controller.text = yearhList[Index];
                                      break;
                              
                              
                              
                                  }
                                  }
                                  );
                                  
                                },
                                
                                child: ListTile(title: Text(
                                  type=="Day"?dayList[Index]:
                                type=="month"?monthList[Index]
                                : yearhList[Index]),
                                )
                                );
                            }
                            )
                            ),
                            );
  }
}