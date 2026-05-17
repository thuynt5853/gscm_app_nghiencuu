using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.DONKHOIKIEN.Personnal.TempBM
{
    public partial class rpt23DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt23DS()
        {
            InitializeComponent();
        }
        
        private void xrTable_NguoiKK_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiKK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiKK.Visible = false;
            }
        }
        private void xrTable_NguoiKK_Ten_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiKK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiKK_Ten.Visible = false;
            }
        }
        private void xrTable_NguoiKK_SDT_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiKK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiKK_SDT.Visible = false;
            }
            else
            {
                xrTable_NguoiKK_SDT.Visible = true;
                if (string.IsNullOrEmpty(r["SoDienThoai"] + "") && string.IsNullOrEmpty(r["Fax"] + ""))
                {
                    xrTable_NguoiKK_SDT.Visible = false;
                }
            }
        }
        private void xrTable_NguoiKK_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiKK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiKK_Email.Visible = false;
            }
            else
            {
                xrTable_NguoiKK_Email.Visible = true;
                if (string.IsNullOrEmpty(r["Email"] + ""))
                {
                    xrTable_NguoiKK_Email.Visible = false;
                }
            }
        }

        private void xrTable_NguoiBK_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiBK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiBK.Visible = false;
            }
        }
        private void xrTable_NguoiBK_Ten_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiBK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiBK_Ten.Visible = false;
            }
        }
        private void xrTable_NguoiBK_SDT_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiBK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiBK_SDT.Visible = false;
            }
            else
            {
                xrTable_NguoiBK_SDT.Visible = true;
                if (string.IsNullOrEmpty(r["SoDienThoai"] + "") && string.IsNullOrEmpty(r["Fax"] + ""))
                {
                    xrTable_NguoiBK_SDT.Visible = false;
                }
            }
        }
        private void xrTable_NguoiBK_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiBK.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NguoiBK_Email.Visible = false;
            }
            else
            {
                xrTable_NguoiBK_Email.Visible = true;
                if (string.IsNullOrEmpty(r["Email"] + ""))
                {
                    xrTable_NguoiBK_Email.Visible = false;
                }
            }
        }

        private void xrTable_QuyenBV_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_QuyenBV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_QuyenBV.Visible = false;
            }
        }
        private void xrTable_QuyenBV_Ten_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_QuyenBV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_QuyenBV_Ten.Visible = false;
            }
        }
        private void xrTable_QuyenBV_SDT_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_QuyenBV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_QuyenBV_SDT.Visible = false;
            }
            else
            {
                xrTable_QuyenBV_SDT.Visible = true;
                if (string.IsNullOrEmpty(r["SoDienThoai"] + "") && string.IsNullOrEmpty(r["Fax"] + ""))
                {
                    xrTable_QuyenBV_SDT.Visible = false;
                }
            }
        }
        private void xrTable_QuyenBV_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_QuyenBV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_QuyenBV_Email.Visible = false;
            }
            else
            {
                xrTable_QuyenBV_Email.Visible = true;
                if (string.IsNullOrEmpty(r["Email"] + ""))
                {
                    xrTable_QuyenBV_Email.Visible = false;
                }
            }
        }

        private void xrTable_NVLQ_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NVLQ.Visible = false;
            }
        }
        private void xrTable_NVLQ_Ten_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NVLQ_Ten.Visible = false;
            }
        }
        private void xrTable_NVLQ_SDT_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NVLQ_SDT.Visible = false;
            }
            else
            {
                xrTable_NVLQ_SDT.Visible = true;
                if (string.IsNullOrEmpty(r["SoDienThoai"] + "") && string.IsNullOrEmpty(r["Fax"] + ""))
                {
                    xrTable_NVLQ_SDT.Visible = false;
                }
            }
        }
        private void xrTable_NVLQ_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NVLQ_Email.Visible = false;
            }
            else
            {
                xrTable_NVLQ_Email.Visible = true;
                if (string.IsNullOrEmpty(r["Email"] + ""))
                {
                    xrTable_NVLQ_Email.Visible = false;
                }
            }
        }

        private void DetailReport_NoiDungDon_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("NoiDungDon") + ""))
            {
                DetailReport_NoiDungDon.Visible = false;
            }
        }

        private void xrTable_NhanChung_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NhanChung.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NhanChung.Visible = false;
            }
        }
        private void xrTable_NhanChung_Ten_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NhanChung.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NhanChung_Ten.Visible = false;
            }
        }
        private void xrTable_NhanChung_SDT_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NhanChung.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NhanChung_SDT.Visible = false;
            }
            else
            {
                xrTable_NhanChung_SDT.Visible = true;
                if (string.IsNullOrEmpty(r["SoDienThoai"] + "") && string.IsNullOrEmpty(r["Fax"] + ""))
                {
                    xrTable_NhanChung_SDT.Visible = false;
                }
            }
        }
        private void xrTable_NhanChung_Email_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NhanChung.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable_NhanChung_Email.Visible = false;
            }
            else
            {
                xrTable_NhanChung_Email.Visible = true;
                if (string.IsNullOrEmpty(r["Email"] + ""))
                {
                    xrTable_NhanChung_Email.Visible = false;
                }
            }
        }

        private void DetailReport_TaiLieu_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_TaiLieu.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_TaiLieu.Visible = false;
                Detail_TaiLieu.Visible = false;
            }
        }

        private void DetailReport_ToaAn_DiaChi_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("TenToaAn_DiaChi") + ""))
            {
                DetailReport_ToaAn_DiaChi.Visible = false;
            }
        }

        private void DetailReport_ThongTinKhac_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("ThongTinKhac") + ""))
            {
                DetailReport_ThongTinKhac.Visible = false;
            }
        }
    }
}
