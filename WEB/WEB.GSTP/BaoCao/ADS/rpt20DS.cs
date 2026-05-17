using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt20DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt20DS()
        {
            InitializeComponent();
        }

        private void SubBand_TP_ThanhVien_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prmTP_ThanhVien"].Value + "" == "")
            {
                SubBand_TP_ThanhVien.Visible = false;
            }
        }

        private void SubBand_HTND_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prmHTND"].Value + "" == "")
            {
                SubBand_HTND.Visible = false;
            }
        }

        private void SubBand_An_8_9_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prmDieuKhoanBoSung"].Value + "" == "2")//Khoản 2 Điều 111 của Bộ luật tố tụng dân sự
            {
                SubBand_An_8_9.Visible = false;
            }
        }

        private void SubBand_An_12_BeforePrint(object sender, CancelEventArgs e)
        {
            if (Parameters["prmDieuKhoanBoSung"].Value + "" == "2")//Khoản 2 Điều 111 của Bộ luật tố tụng dân sự
            {
                SubBand_An_12.Visible = false;
            }
        }
    }
}
