#include <openPMD/openPMD.hpp>

#include <cstddef>
#include <iostream>
#include <memory>

using std::cout;
using namespace openPMD;

class Timer
{  
public:
  Timer(const std::string& tag)
    :m_Tag(tag)
  {
    m_Start = std::chrono::system_clock::now();
  }
  ~Timer()
  {
    m_End = std::chrono::system_clock::now();

    double millis = std::chrono::duration_cast<std::chrono::milliseconds>(m_End - m_Start).count();
      
    double secs = millis / 1000.0;

    if (secs >  0)
      std::cout << "  [" << m_Tag << "] took:" << secs << " seconds" << std::endl;
    else
      std::cout << "  [" << m_Tag << "] took:" << millis << " milli seconds" << std::endl;
  }
private:
  std::chrono::time_point<std::chrono::system_clock> m_Start;
  std::chrono::time_point<std::chrono::system_clock> m_End;
  
  std::string m_Tag;
};
    
int main(int argc, char *argv[])
{
  Timer total("Total:");
  if (argc < 4) {
    std::cout<<" Please supply a  file name, type, encoding "<<std::endl;
    return 0;
  }
  std::string fileName = argv[1];
  std::string type = argv[2];
  std::string encoding = argv[3];
    
  if (encoding == "f")
    fileName +="%T";
  fileName += ".";
  fileName +=type;

  std::cout<<fileName<<std::endl;

  Access readMode = Access::READ_ONLY;
  if (encoding == "v")
    readMode = Access::READ_LINEAR;
  
  Timer* openTimer = new Timer("opening series: ");
  Series series = Series(fileName, readMode); //Access::READ_ONLY);
  if ( Access::READ_ONLY == readMode )
    cout << "Read a Series with openPMD standard version " << series.openPMD()<< '\n';
  else
    cout << "Stream READ .. "<<'\n';
  cout << "The Series contains " << series.iterations.size() << " iterations\n";

  delete openTimer;
  
  /*
  #  for it in iterations:
  #  begin_time = time.time()
  #  Ex, info_Ex = ts.get_field( 'E', coord='x', iteration=it )
  #  end_time = time.time()
  #  print(f"Time to get fields: {end_time - begin_time:.4f} s")
  */

  int counter = 0;
  for (auto i : series.readIterations()) {
     std::string s = std::to_string(counter);
     Timer g(s);
     counter ++;
    //Timer g( "curr step");
    auto ex = i.meshes["E"]["x"];
    Extent extent = ex.getExtent();

    auto all_data = ex.loadChunk<double>();
    //std::cout<< all_data.get()[0]<<std::endl;
    //std::cout<< all_data.get()[1]<<std::endl;
    i.close();

    //break;
  }
   
  series.close();
  return 0;
}
