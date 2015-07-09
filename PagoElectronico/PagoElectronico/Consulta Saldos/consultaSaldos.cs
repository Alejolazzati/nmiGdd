using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Consulta_Saldos
{
    public partial class consultaSaldos : Form
    {
        String cuenta;
        public consultaSaldos(String numeroCuenta)
        {
            InitializeComponent();
            cuenta = numeroCuenta;
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select dbo.saldoCuenta(" + cuenta + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox1.Text=reader.GetSqlValue(0).ToString();
            reader.Dispose();
            comando.CommandText = "Select * from ultimos5Depositos(" + cuenta + ")";
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            DataSet set=new DataSet();
            adapter.Fill(set);
            dataGridView1.DataSource = set.Tables[0].DefaultView;
            adapter.Dispose();
            set.Dispose();
            adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            set = new DataSet();            
            comando.CommandText = "Select * from ultimos5Retiros(" + cuenta + ")";
            adapter.Fill(set);
            dataGridView2.DataSource = set.Tables[0].DefaultView;
            adapter.Dispose();
            set.Dispose();
            adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            set = new DataSet();
            comando.CommandText = "Select * from ultimas10Transf(" + cuenta + ")";
            adapter.Fill(set);
            dataGridView3.DataSource = set.Tables[0].DefaultView;
        
        }

        private void consultaSaldos_Load(object sender, EventArgs e)
        {

        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void dataGridView1_CellContentClick_1(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
