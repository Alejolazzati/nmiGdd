using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Facturacion
{
    public partial class Facturacion : Form
    {
        bool cierre=true;

        public Facturacion()
        {
            InitializeComponent();
        }

        protected override void OnFormClosing(FormClosingEventArgs e)
        {
            
              if (cierre)
                {
                    System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
                    comando.CommandText = "Rollback transaction factu";
                    comando.ExecuteNonQuery();
                }
                else cierre = true;
                new PagoElectronico.Login.Funcionalidades().Show();
            
            base.OnFormClosing(e);
        }

   
        private void Facturacion_Load(object sender, EventArgs e)
        {
            

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "begin transaction factu";
            comando.ExecuteNonQuery();
            
            comando.CommandText = "NMI.facturar";
            comando.CommandType = CommandType.StoredProcedure;
            comando.Parameters.Add("@numCliente", SqlDbType.Decimal);
            comando.Parameters.Add("@fact", SqlDbType.Decimal);
            comando.Parameters["@numCliente"].Value = Program.cliente;
            comando.Parameters["@fact"].Value = Program.cliente;
            comando.Parameters["@fact"].Direction = ParameterDirection.Output;
            try
            {
                comando.ExecuteNonQuery();   
                //System.Data.SqlClient.SqlDataReader reader= comando.ExecuteReader();
               // reader.Read();
                //Program.factura = reader.GetSqlDecimal(reader.GetOrdinal("@fact"));
                Program.factura = (System.Data.SqlTypes.SqlDecimal) comando.Parameters["@fact"].SqlValue;
               
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
                new PagoElectronico.Login.Funcionalidades().Show();
                this.Close();

            }
            finally{
                comando.Parameters.Clear();
                comando.CommandType = CommandType.Text;
            }

        }

        private void button3_Click(object sender, EventArgs e)
        {
           new  PagoElectronico.Login.SeleccionarCuenta(2).Show();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "commit transaction factu";
            comando.ExecuteNonQuery();
            new PagoElectronico.Facturacion.ListadoFactura().Show();
            cierre = false;
            this.Close();
          
        }

        
        
    }
}
