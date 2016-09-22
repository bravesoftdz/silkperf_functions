//-------------------------------------------------------------------
// Benchmark Script Template
//-------------------------------------------------------------------
// Author : Dinanath Basumatary
// Date   : 22/09/2016
// History: 
//-------------------------------------------------------------------
// Benchmark Description:
// 
//-------------------------------------------------------------------

benchmark Functions
 
use "kernel.bdh" 
use "json.bdh"
 
// Definition of global variables: string, number, float, boolean, array
var      
  NumVar  : number; 
  StrVar1 : string;      // default size see product documentation
  StrVar2 : string(50);  // size 50 characters exclusive NULL-term
  FltVar  : float; 
  BoolVar : boolean; 
  ArrVar  : array [5] of number; // number item index from 1 to 5
  ArrVar1  : array of number init 5,4,7,9,1,4,2,6,3,23,5,0,8;
  i,j,k : number;
  hFile, nSize : number;
  sFileName : string init "json.txt";
  sFileContent: string;
  nOccupied : number;
  
  hJson, hJsonDeliveryAddresses, hJsonAddresses, hJsonAddress : number;
  sId, sLine1: string;
  
  
// Random Variables Section 
dclrand
  rnUniN            : RndUniN  (1..100);  
  
// Workload Section 
dcluser  
  user
    VirtUser
  transactions
    TInit           : begin;  // Initialization
    Trans       : 1;     // Transactions
    TEnd            : end;    // Termination
                              
// Transactions Section

dclfunc

dcltrans
  transaction TInit
  begin     
    
    Print("sizeof(ArrVar): "+string(sizeof(ArrVar)/4));
    Print("sizeof(ArrVar1): "+string(sizeof(ArrVar1)/4));

    //Getting the actual size of a number array
    nOccupied := 0;
    for i := 1 to sizeof(ArrVar1)/4 do
      if (ArrVar1[i] <> null) or (ArrVar1[i]=0) then
        nOccupied := nOccupied +1;
      end;
    end;
    Print("Actual occupied: "+string(nOccupied));
    
    //-------------------------------------------

    
  end TInit;
  
  transaction Trans
  begin
    
    //Insertion sort
    for i:=1 to nOccupied-1 do
      j:=i;
      while (j > 0) and (ArrVar1[j] < ArrVar1[j+1]) do // for ascending order set expression to ArrVar1[j] > ArrVar1[j+1]
        k := ArrVar1[j];
        ArrVar1[j] := ArrVar1[j+1];
        ArrVar1[j+1] := k;
        j := j-1;
      end;
    end;
    
    Print("Sorted! now printing");
    
    for i:=1 to nOccupied do
      Print(string(ArrVar1[i]));
      
    end;
    // ---------------------------------------- end of insertion sort
    
    
    //Open file to get the json content
    FOpen(hFile, sFileName);
    FSizeGet(hFile, nSize);
    Print("File Size: "+ string(nSize));
    
    FRead(hFile,sFileContent, nSize);
    
    write(sFileContent);
    
    //Lets do some json parsing.
    
    hJson := JsonParse(sFileContent);
    
    // get the property deliveryaddresses which is an object
    JsonGetObjectProperty(hJson, "deliveryAddresses", hJsonDeliveryAddresses);
    
    // get the property called addresses which is an array of objects
    JsonGetArrayProperty(hJsonDeliveryAddresses, "addresses", hJsonAddresses);
    
    // get the first element from the array
    JsonArrayGetObjectElement(hJsonAddresses, 0, hJsonAddress);
    
    // get the properties from from the address object
    JsonGetStringProperty(hJsonAddress, "id", sId); 
    JsonGetStringProperty(hJsonAddress, "line1", sline1);
    
    Print("Address id: "+sId+" line1: "+ sline1);
    
    //------------------------------------------------------------------------- phew!
    
  end Trans;

  transaction TEnd
  begin
    // Terminate the user
  end TEnd;
