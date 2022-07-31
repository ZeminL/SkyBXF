using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;

namespace WindowsFormsApp1
{
    public partial class Form1 : Form
    {
        private string curDir;
        private List<Participant> ParInfo = new List<Participant>();

        public Form1()
        {
            InitializeComponent();
            try
            {            
                curDir = Directory.GetCurrentDirectory() + "\\Result";
                string[] dirs = Directory.GetDirectories(curDir, "Participant_*");            
                foreach (var i in dirs)
                {
                    checkedListBox1.Items.Add(i.Substring(curDir.Length + 1));
                    Participant p = JsonConvert.DeserializeObject<Participant>(File.ReadAllText(i + "\\ParticipantInfo.json"));
                    ParInfo.Add(p);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private void checkedListBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            listView1.Items.Clear();
            Participant p = ParInfo[checkedListBox1.SelectedIndex];
            ListViewItem liv0 = new ListViewItem();
            liv0.Text = "ID";
            liv0.SubItems.Add(p.ID.ToString());
            listView1.Items.Add(liv0);
            ListViewItem liv1 = new ListViewItem();
            liv1.Text = "Session";
            liv1.SubItems.Add(p.Session.ToString());
            listView1.Items.Add(liv1);
            ListViewItem liv2 = new ListViewItem();
            liv2.Text = "Block";
            liv2.SubItems.Add(p.Block.ToString());
            listView1.Items.Add(liv2);
            ListViewItem liv3 = new ListViewItem();
            liv3.Text = "Trial";
            liv3.SubItems.Add(p.Trial.ToString());
            listView1.Items.Add(liv3);
            ListViewItem liv4 = new ListViewItem();
            liv4.Text = "Gender";
            liv4.SubItems.Add(p.Gender.ToString());
            listView1.Items.Add(liv4);
            ListViewItem liv5 = new ListViewItem();
            liv5.Text = "Handedness";
            liv5.SubItems.Add(p.Handedness.ToString());
            listView1.Items.Add(liv5);
        }

        private List<string[]> DataRead(Participant p, string path)
        {
            string[] files = Directory.GetFiles(path, "result_" + p.ID + "*.json");
            List<string[]> datas = new List<string[]>();
            for (int i = 0; i < files.Length; i++)
            {
                FileInfo fileInfo = new FileInfo(files[i]);
                var data = JsonConvert.DeserializeObject<Result_Data>(File.ReadAllText(fileInfo.FullName)).data;
                if (i == 0)
                {
                    datas.Add(data);
                }
                else
                {
                    string[] d = new string[data.Length - 1];
                    for (int j = 1; j < data.Length; j++)
                    {
                        d[j - 1] = data[j];
                    }
                    datas.Add(d);
                }
            }
            return datas;
        }

        private void DataWrite(Participant p, List<string[]> datas)
        {
            string fullPath = curDir + "\\Data_CSV\\Data_" + p.ID + ".csv";
            FileInfo CSVfile = new FileInfo(fullPath);
            if (!CSVfile.Directory.Exists)
            {
                CSVfile.Directory.Create();
            }
            FileStream fs = new FileStream(fullPath, System.IO.FileMode.Create, System.IO.FileAccess.Write);
            StreamWriter sw = new StreamWriter(fs, System.Text.Encoding.UTF8);
            foreach (var item in datas)
            {
                foreach (var i in item)
                {
                    sw.WriteLine(i);
                }
            }

            sw.Close();
            fs.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            var r = new List<int>();
            for (int i = 0; i < checkedListBox1.Items.Count; i++)
            {
                if (checkedListBox1.GetItemChecked(i))
                {
                    string s = curDir + "\\" + checkedListBox1.Items[i].ToString();
                    var list = DataRead((Participant)ParInfo[i], s);
                    DataWrite((Participant)ParInfo[i], list);
                    r.Add(ParInfo[i].ID);
                }
            }
            string result = "";
            int n = 0;
            foreach (var item in r)
            {
                n++;
                result += item;
                if (n != r.Count)
                {
                    result += ", ";
                }
            }
            MessageBox.Show("The data of the following participants has been successfully merged and exported: \n" + result,"");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < checkedListBox1.Items.Count; i++)
            {
                if (checkedListBox1.GetItemChecked(i))
                {
                    checkedListBox1.SetItemChecked(i, false);
                }
                else
                {
                    checkedListBox1.SetItemChecked(i, true);
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            for (int i = 0; i < checkedListBox1.Items.Count; i++)
            {
                checkedListBox1.SetItemChecked(i, true);
            }
        }

        private void listView1_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }
    }

    public class Participant
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Gender { get; set; }
        public string Handedness { get; set; }
        public int Session { get; set; }
        public int Block { get; set; }
        public int Trial { get; set; }
    }

    public class Result_Data
    {
        public string[] data { get; set; }
    }
}