//using BL.GSTP.Danhmuc;
//using BL.GSTP;
//using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;

namespace WEB.GSTP.QTDKK.DSTaikhoanND
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
                    LoadDropLoaiUser();
                    hddPageIndex.Value = "1";
                    Load_Data();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                  //  Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        private void LoadDropLoaiUser()
        {
            dropLoaiUser.Items.Clear();
            dropLoaiUser.Items.Add(new ListItem("--- Tất cả ---", "0"));
            dropLoaiUser.Items.Add(new ListItem("Cá nhân", "1"));
            dropLoaiUser.Items.Add(new ListItem("Doanh nghiệp", "2"));
            dropLoaiUser.Items.Add(new ListItem("Tổ chức", "3"));

            //---------------------------
            dropMucdichSD.Items.Clear();
            dropMucdichSD.Items.Add(new ListItem("--- Tất cả---", "0"));
            dropMucdichSD.Items.Add(new ListItem("Nhận VB tống đạt", "2")); // không sử dụng chữ ký số
            dropMucdichSD.Items.Add(new ListItem("Nộp đơn khởi kiện", "1"));//co sử dụng chữ ký số
        }
        private void Load_Data()
        {
            lbtthongbao.Text = "";
            DataTable oDT = null;
            DONKK_USERS_BL objBL = new DONKK_USERS_BL();
            int CurPage = Convert.ToInt32(hddPageIndex.Value);
            int PageSize = Convert.ToInt32(hddPageSize.Value);
            string searchKey = txKey.Text.Trim();
            int loaitaikhoan = Convert.ToInt16(dropLoaiUser.SelectedValue);
            int MucdichSD = Convert.ToInt16(dropMucdichSD.SelectedValue);
            int DKThayDoi = Convert.ToInt16(dropDKThaydoi.SelectedValue);
            oDT = objBL.GetAllPaging(searchKey, loaitaikhoan, MucdichSD, DKThayDoi, CurPage, PageSize);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(oDT.Rows[0]["CountAll"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
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

            dgList.DataSource = oDT;
            dgList.DataBind();

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
        protected void btnThemmoi_Click(object sender, EventArgs e)
        {
            Response.Redirect("Capnhat.aspx");
        }
        void XoaTaiKhoan(Decimal ID)
        {
            Decimal DonKKID = 0;
            try
            {
                List<DONKK_DON> lstDon = dt.DONKK_DON.Where(x => x.NGUOITAO == ID).ToList();
                if (lstDon != null)
                {
                    foreach (DONKK_DON itemDon in lstDon)
                    {
                        DonKKID = itemDon.ID;
                        //-----------------------------
                        try
                        {
                            List<DONKK_DON_TAILIEU> lstTL = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == DonKKID).ToList();
                            if (lstTL != null)
                            {
                                foreach (DONKK_DON_TAILIEU itemTL in lstTL)
                                    dt.DONKK_DON_TAILIEU.Remove(itemTL);
                            }
                        }
                        catch (Exception ex) { }
                        //---------------------------------
                        try
                        {
                            List<DONKK_USER_DKNHANVB> lstTL = dt.DONKK_USER_DKNHANVB.Where(x => x.DONKKID == DonKKID).ToList();
                            if (lstTL != null)
                            {
                                foreach (DONKK_USER_DKNHANVB itemDK in lstTL)
                                    dt.DONKK_USER_DKNHANVB.Remove(itemDK);
                            }
                        }
                        catch (Exception ex) { }
                        //---------------------------------
                        try
                        {
                            List<DONKK_DON_DUONGSU> lstTL = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == DonKKID).ToList();
                            if (lstTL != null)
                            {
                                foreach (DONKK_DON_DUONGSU itemDS in lstTL)
                                    dt.DONKK_DON_DUONGSU.Remove(itemDS);
                            }
                        }
                        catch (Exception ex) { }
                        //-------------------------------------
                        dt.DONKK_DON.Remove(itemDon);
                    }
                }
            }
            catch(Exception ex) { }

            //--------------------------------
            DONKK_USERS cbo = dt.DONKK_USERS.Where(x => x.ID == ID).FirstOrDefault<DONKK_USERS>();
            if (cbo != null)
                dt.DONKK_USERS.Remove(cbo);

            dt.SaveChanges();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument);
            DONKK_USERS cbo = null;
            switch (e.CommandName)
            {
                case "Sua":
                    Response.Redirect("Capnhat.aspx?tk=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    XoaTaiKhoan(ID);
                    hddPageIndex.Value = "1";
                    Load_Data();
                    lbtthongbao.Text = "Xóa tài khoản thành công!";
                    break;
                case "Khoa":
                    cbo = dt.DONKK_USERS.Where(x => x.ID == ID).FirstOrDefault<DONKK_USERS>();
                    if (cbo != null)
                    {
                        cbo.STATUS = 1;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    lbtthongbao.Text = "Khóa tài khoản thành công!";
                    break;
                case "KichHoat":
                    cbo = dt.DONKK_USERS.Where(x => x.ID == ID).FirstOrDefault<DONKK_USERS>();
                    if (cbo != null)
                    {
                        cbo.STATUS = 2;
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    lbtthongbao.Text = "Kích hoạt tài khoản thành công!";
                    break;
                //case "MatKhau":
                //    if (cbo != null)
                //    {
                //        string str_mk = "123456a@";
                //        str_mk = Cls_Comon.Randomnumber();
                //        cbo.ACTIVATIONCODE= Guid.NewGuid().ToString();
                //        cbo.PASSWORD = Cls_Comon.MD5Encrypt(str_mk);
                //        cbo.PASSWORDMODIFIEDDATE= DateTime.Now;
                //        dt.SaveChanges();

                //        Module.Common.Cls_SendMail.SendResetMatKhau(cbo.EMAIL, cbo.NDD_HOTEN, cbo.EMAIL, str_mk);
                //    }
                //    hddPageIndex.Value = "1";
                //    Load_Data();
                //    lbtthongbao.Text = "Khởi tạo mật khẩu thành công!";
                //    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    DataRowView row = (DataRowView)e.Item.DataItem;
                    ImageButton cmdEdit = (ImageButton)e.Item.FindControl("cmdEdit");
                    cmdEdit.Visible = oPer.CAPNHAT;

                    ImageButton cmdXoa = (ImageButton)e.Item.FindControl("cmdXoa");
                    cmdXoa.Visible = oPer.XOA;

                    ImageButton cmdLock = (ImageButton)e.Item.FindControl("cmdLock");
                    ImageButton cmdUnlock = (ImageButton)e.Item.FindControl("cmdUnlock");
                    cmdLock.Visible = cmdUnlock.Visible =  oPer.CAPNHAT;

                    String status = (String.IsNullOrEmpty(row["STATUS"] + "")) ? "1" : row["STATUS"] + "";
                    switch(status)
                    {
                        case "0":
                            if (oPer.CAPNHAT)
                                cmdLock.Visible =false;
                                cmdEdit.Visible =  cmdUnlock.Visible = true;
                            break;
                        case "1":
                            if (oPer.CAPNHAT)
                                cmdUnlock.Visible = cmdEdit.Visible =true;
                            cmdLock.Visible =  false;
                            break;
                        case "2":
                            if (oPer.CAPNHAT)
                            {
                                cmdLock.Visible =  true;
                                cmdUnlock.Visible = false;
                            }
                            break;
                    }
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
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