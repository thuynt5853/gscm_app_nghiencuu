
using System;
using System.Data;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class DsDuongSu : System.Web.UI.UserControl
    {
       
        private decimal donid;
        public decimal DonKKID
        {
            get { return donid; }
            set { donid = value; }
        }

        protected string ma_loai_an;
        public String MaLoaiVuViec
        {
            get { return ma_loai_an; }
            set { ma_loai_an = value; }
        }

        protected decimal quanhepl;
        public decimal QuanHePhapLuatID
        {
            get { return quanhepl; }
            set { quanhepl = value; }
        }
        
        //--------------------------------
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");

        public decimal DonID = 0;
        public string UYQUYEN = "", BIDON = "", NGUYENDON = "", QUYENNVLQ = "", KHAC="";
        public decimal DuongSuID = 0;
        public decimal QHPL_ID = 0;
        public String MaLoaiVV = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID > 0)
            {
                KHAC = ENUM_DANSU_TUCACHTOTUNG.KHAC;
                if (Request["ID"] != null)
                    this.DonKKID = Convert.ToDecimal(Request["ID"] + "");

                if (!String.IsNullOrEmpty(MaLoaiVuViec))
                {
                    MaLoaiVV = this.MaLoaiVuViec;
                    QHPL_ID = QuanHePhapLuatID;  
                }

                DonID = DonKKID;
                if (DonKKID > 0)
                {
                    lttLink.Text = "";
                    lttLink.Visible = false;
                }
                else
                {
                    lttLink.Text = " <a href='javascript:;' id='lkDuongSuKhac' onclick='show_popup_ds()'";
                    lttLink.Text += " class='link_them_duongsu align_right'>Thêm đương sự khác</a>";
                    lttLink.Visible = true;
                }
                LoadDsDuongSuKhac();                  
            }
        }
        //------------------------
        #region Load DS
        public void LoadDsDuongSuKhac()
        {
            DataTable oDT = null;
            DONKK_DON_DUONGSU_BL oBL = new DONKK_DON_DUONGSU_BL();
            oDT = oBL.GetByDonKKID(DonKKID, MaLoaiVuViec);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                int count_all = oDT.Rows.Count;
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = oDT;
                rpt.DataBind();
                pnDuongSu.Visible = pnDanhSach.Visible = true;
            }
            else
            {
                if (this.DonKKID > 0)
                    pnDuongSu.Visible = false;
                else
                {
                    pnDuongSu.Visible = true;
                    pnDanhSach.Visible = false;
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    xoa(ND_id);
                    LoadDsDuongSuKhac();
                    break;
            }
        }
        public void xoa(decimal id)
        {
            //KT: Neu da co GSTP.DonID --> xoa trong phan GSTP 
            //ko co --> xoa trong DOnKK
            DONKK_DON_DUONGSU oND = dt.DONKK_DON_DUONGSU.Where(x => x.ID == id).FirstOrDefault();
            decimal DONID = (decimal)oND.DONKKID;
            if (oND.ISDAIDIEN == 1)
            {
               // lbthongbao.Text = "Không được xóa đương sự đại diện.";
                return;
            }

            dt.DONKK_DON_DUONGSU.Remove(oND);
            dt.SaveChanges();

            LoadDsDuongSuKhac();
            
            //lbthongbao.Text = "Xóa thành công!";
            //DONKK_DON_DUONGSU_BL oDonBL = new DONKK_DON_DUONGSU_BL();
            //oDonBL.Update_YeuToNuocNgoai(DONID, QuocTichVN);
        }
        #region "Phân trang ds duong su"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDsDuongSuKhac();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {

            hddPageIndex.Value = "1";
            LoadDsDuongSuKhac();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDsDuongSuKhac();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDsDuongSuKhac();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            //dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDsDuongSuKhac();
        }

        #endregion
        #endregion
    }
}