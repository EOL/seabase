import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import java.util.Properties;
import com.mysql.jdbc.Driver;
import java.io.PrintWriter;

public class CosineCalc {
  private static final String dbClassName = "com.mysql.jdbc.Driver";
  private static final String CONNECTION =
    "jdbc:mysql://localhost/seabase_dev";
  private static List<Integer> transcripts_ids = 
    new ArrayList<Integer>();
  private static HashMap<Integer, List<Integer>> vectors = 
    new HashMap<Integer, List<Integer>>();
  private static Connection c;
  private static Statement st;
  private static ResultSet rs;
  private static Integer tr_id;

  public static void main(String[] args) {
    get_connection();
    get_transcript_ids();
    get_vectors();
    close_connection();
    calculate();
  }

  private static Double cosine_similarity(List<Integer> a, 
      List<Integer> b) {
    Double prod = dot_product(a, b);
    Double len1 = Math.sqrt(dot_product(a, a));
    Double len2 = Math.sqrt(dot_product(b, b));
    Double cosine = prod / (len1 * len2);
    return cosine;
  }

  private static Double dot_product(List<Integer> a,
      List<Integer> b) {
    Double result = 0.0;
    for (Integer i = 0; i < a.size(); ++i) {
      result += a.get(i) * b.get(i);
    }
    return result;
  }

  private static void calculate(){
    try {
      PrintWriter writer = new PrintWriter("similarities.tsv", "UTF-8");
      System.out.println("Calculating cosine");
      for (Map.Entry<Integer, 
          List<Integer>> entry1: vectors.entrySet()) {
        Integer key1 = entry1.getKey();
        System.out.println(key1);
        for (Map.Entry<Integer, List<Integer>> entry2: 
            vectors.entrySet()) {
          Integer key2 = entry2.getKey();
          if(key1 != key2) {
            Double similarity = cosine_similarity(entry1.getValue(), 
                entry2.getValue());
            String result = String.format("%s\t%s\t%.3f", 
                key1, key2, similarity);
            writer.println(result);
            /* System.out.println(result); */
          }
        }
      }
      writer.close();
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }
private static void get_vectors() {
    try {
      System.out.println("Collecting vectors");

      for( Integer i = 0; i < transcripts_ids.size(); ++i ) {
        tr_id = transcripts_ids.get(i);
        st = c.createStatement();
        String q = 
          "select sum(`count`) " + 
          "from normalized_counts where " +
          "transcript_id = " +
          String.valueOf(tr_id) +
          " group by stage order by stage";
        rs = st.executeQuery(q);

        List<Integer> values = new ArrayList<Integer>();

        while (rs.next()) {
          Integer value = rs.getInt(1);
          values.add(value);
        }

        vectors.put(tr_id, values);

        if (tr_id % 10000 == 0) {
          System.out.println("Transcript " + String.valueOf(tr_id));
        }
      }
    } catch (Exception e) {
      System.out.println(e.getMessage());
    }
  }

  private static void get_connection() {
    try {
      Class.forName("com.mysql.jdbc.Driver");

      Properties p = new Properties();
      p.put("user", "root");
      c = DriverManager.getConnection(CONNECTION, p);
    } catch (ClassNotFoundException e) {
      System.out.println(e.getMessage());
    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }

  private static void get_transcript_ids() {
    try {
      st = c.createStatement();
      rs = st.executeQuery("select id from transcripts limit 10000");

        while (rs.next()) {
            transcripts_ids.add(rs.getInt(1));
        }

    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }
  
  private static void close_connection() {
    try {
      c.close();
    } catch (SQLException e) {
      System.out.println(e.getMessage());
    }
  }
}
