using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK;

namespace WEB.GSTP.QTDKK.DKDoiTK
{
    public partial class Danhsach : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        private const int ROOT = 0;
        private string PUBLIC_DEPT = "...";
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    Load_Data();
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //  Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        
        private void Load_Data()
        {
            lbtthongbao.Text = "";
            DataTable tbl = null;
            DONKK_USER_DOITK_BL objBL = new DONKK_USER_DOITK_BL();
            int CurPage = Convert.ToInt32(hddPageIndex.Value);
            int PageSize = Convert.ToInt32(hddPageSize.Value);
          
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            decimal status =Convert.ToDecimal( dropStatus.SelectedValue);
            string madangky = txtMaDangKy.Text.Trim();
            string hoten = txtHoTen.Text.Trim();
            string email = txtEmaiil.Text.Trim();
            string cmnd = txtCMND.Text.Trim();
            tbl = objBL.GetAllPaging(ToaAnID, status,madangky, hoten, email, cmnd, CurPage, PageSize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(tbl.Rows[0]["CountAll"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> đăng ký trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            rpt.DataSource = tbl;
            rpt.DataBind();
        }
        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        //protected void btnThemmoi_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("Capnhat.aspx");
        //}

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            Decimal DangKyID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    Xoa(DangKyID);
                    break;
                case "Active":
                    Active(DangKyID);
                    break;
            }
        }
        void Xoa(Decimal DangKyID)
        {
            DONKK_USER_DOIMUCDICHSD cbo = dt.DONKK_USER_DOIMUCDICHSD.Where(x => x.ID == DangKyID).FirstOrDefault<DONKK_USER_DOIMUCDICHSD>();
            if (cbo != null)
            {
                dt.DONKK_USER_DOIMUCDICHSD.Remove(cbo);
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                Load_Data();
                lbtthongbao.Text = "Xóa mục chọn thành công!";
            }
        }
        void Active(Decimal DangKyID)
        {
            DONKK_USER_DOIMUCDICHSD cbo = dt.DONKK_USER_DOIMUCDICHSD.Where(x => x.ID == DangKyID).FirstOrDefault<DONKK_USER_DOIMUCDICHSD>();
            if (cbo != null)
            {
                DONKK_USERS obj = dt.DONKK_USERS.Where(x => x.ID == cbo.USERID).Single();
                if (obj!= null)
                {
                    cbo.STATUS = 1;
                    cbo.HOTEN_OLD = obj.NDD_HOTEN;
                    cbo.EMAIL_OLD = obj.EMAIL;
                    cbo.CMND_OLD = obj.NDD_CMND;
                    cbo.MASOTHUE_OLD = obj.DN_MASOTHUE;
                    cbo.USERTYPE_OLD = obj.USERTYPE;
                    cbo.NGUOIDUYET = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                    cbo.NGAYDUYET = DateTime.Now;

                    //---------------------
                    obj.NDD_HOTEN = cbo.HOTEN_NEW;
                    obj.EMAIL = cbo.EMAIL_NEW;
                    obj.NDD_CMND = cbo.CMND_NEW;
                    obj.DN_MASOTHUE = cbo.MASOTHUE_NEW;
                    obj.MUCDICH_SD = 1;
                    if (!String.IsNullOrEmpty(cbo.MASOTHUE_NEW ))
                    {
                        if (obj.USERTYPE == 0)
                            obj.USERTYPE = cbo.USERTYPE_NEW;
                    }
                    obj.MODIFIEDDATE= DateTime.Now;
                }
                dt.SaveChanges();

                hddPageIndex.Value = "1";
                Load_Data();
                lbtthongbao.Text = "Xét duyệt đổi thông tin tài khoản thành công!";
            }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                int trangthai = Convert.ToInt16(rv["Status"] + "");

                ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                cmdXoa.Visible = oPer.XOA;

                ImageButton cmdActive = (ImageButton)e.Item.FindControl("cmdActive");
                cmdActive.Visible = oPer.CAPNHAT;
                
                //0:chưa dc duoc duyet, 1: da duyet
                switch (trangthai)
                {
                    case 0:
                        cmdActive.Visible = true;
                        cmdXoa.Visible = true;
                        break;
                    case 1:
                        cmdActive.Visible = false;
                        cmdXoa.Visible = false;
                        break;
                }
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #endregion

    }
}