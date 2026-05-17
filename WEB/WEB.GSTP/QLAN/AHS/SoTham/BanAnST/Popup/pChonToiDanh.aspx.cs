using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;
using BL.GSTP.AHS;

namespace WEB.GSTP.QLAN.AHS.SoTham.BanAnST.Popup
{
    public partial class pChonToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal BanAnID = 0, BiCaoID = 0, VuAnID=0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
            {
                BanAnID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");
                VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                if (!IsPostBack)
                { BiCaoID = (String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");
               
                    LoadDrop();
                    LoadGrid();
                    CheckQuyen();
                }
            } 
            else
                Response.Redirect("/Login.aspx");   
        }
        void CheckQuyen()
        {
            decimal ID = Session[ENUM_LOAIAN.AN_HINHSU] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdSave, false);
                Cls_Comon.SetButton(cmdSave2, false);
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VuAnID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdSave, false);
                Cls_Comon.SetButton(cmdSave2, false);
                return;
            }
        }
        
        void LoadDrop()
        {
            List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
            if (lstBC != null && lstBC.Count > 0)
            {
                dropBiCao.Items.Clear();
                foreach (AHS_BICANBICAO obj in lstBC)
                    dropBiCao.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));
                try
                {
                    if (Request["bID"] != null)
                        dropBiCao.SelectedValue = Request["bID"] + "";
                }
                catch (Exception ex) { }
            }
            //------------------------
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1 
                            && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            //dropBoLuat.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));
            }
        }
        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (dropBiCao.SelectedValue != "" && dropBiCao.SelectedValue != "0")
                {
                    string link = "/QLAN/AHS/SoTham/BanAnST/Popup/pChonToiDanh.aspx?aID=" + BanAnID + "&bID=" + dropBiCao.SelectedValue;
                    Response.Redirect(link);
                }
            }
            catch (Exception ex) {  }
        }
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            AHS_SOTHAM_BANAN_DIEU_CHITIET obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            String OldChange = hddOld.Value;
            string temp = "";
            String DelItem = "|";
            foreach(RepeaterItem item in rpt.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chk");
                HiddenField hddBoLuatID = (HiddenField)item.FindControl("hddBoLuatID");
                HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                HiddenField hddLoai = (HiddenField)item.FindControl("hddLoai");
                
                temp = "|" + hddBoLuatID.Value + ";" + hddToiDanhID.Value + "|";
                if (!string.IsNullOrEmpty(OldChange))
                {
                    if (OldChange.Contains(temp))
                    {
                        if (!chk.Checked)
                            DelItem += hddBoLuatID.Value + ";" + hddToiDanhID.Value + "|";
                    }
                    else
                    {
                        if (chk.Checked)
                            ThemToiDanh(hddBoLuatID.Value, hddToiDanhID.Value, hddLoai.Value);
                    }
                }
                else
                {
                    if (chk.Checked)
                        ThemToiDanh(hddBoLuatID.Value, hddToiDanhID.Value, hddLoai.Value);
                }
            }
            //---------------------------------------
            if ((!string.IsNullOrEmpty(DelItem)) && (DelItem != "|"))
                XoaToiDanh(DelItem);
            
            //---------------------------------------
            lbthongbao.Text = "Lưu thông tin cho bị cáo:"+ dropBiCao.SelectedItem.Text + " thành công!";
        }
        void XoaToiDanh(string DelItem)
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            decimal ban_an_id = Convert.ToDecimal(Request["aID"] + "");
            decimal boluatid = 0, toidanhid = 0;
            string[] arr_child = null;
            string[] arr = DelItem.Split("|".ToArray());
            
            foreach (String item in arr)
            {
               if (item.Length > 0)
               {
                    arr_child = item.Split(";".ToCharArray());
                    boluatid = Convert.ToDecimal(arr_child[0] + "");
                    toidanhid = Convert.ToDecimal(arr_child[1] + "");

                    List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                                                      && x.BANANID == ban_an_id
                                                                                                      && x.DIEULUATID == boluatid
                                                                                                      && x.TOIDANHID == toidanhid
                                                                                                  ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                    if (lst.Count > 0)
                    {
                        foreach(AHS_SOTHAM_BANAN_DIEU_CHITIET obj  in lst)
                            dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Remove(obj);
                        dt.SaveChanges();
                    }
                }
            }
        }
        void ThemToiDanh(string strboluatid, string strtoidanhid, string loai_toidanh)
        {
            
            Decimal boluatid = Convert.ToDecimal(strboluatid);
            decimal toidanhid = Convert.ToDecimal(strtoidanhid);
            String[] arrToiDanh = null;
            DM_BOLUAT_TOIDANH objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
            arrToiDanh = objTD.ARRSAPXEP.Split('/');
            if (arrToiDanh != null && arrToiDanh.Length > 0)
            {
                decimal ChuongID = Convert.ToDecimal(arrToiDanh[0] + "");
                foreach (String strToiDanhID in arrToiDanh)
                {
                    if (strToiDanhID.Length > 0 && strToiDanhID != ChuongID.ToString())
                    {
                        toidanhid = Convert.ToDecimal(strToiDanhID);
                        InsertToiDanh( BanAnID, toidanhid, objTD.TENTOIDANH);
                    }
                }
                dt.SaveChanges();
            }
        }
        void InsertToiDanh(Decimal BanAnID, Decimal toidanhid, string tentoidanh)
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            bool isupdate = false;
            AHS_SOTHAM_BANAN_DIEU_CHITIET obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            try
            {
                obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                                && x.VUANID == VuAnID
                                                                && x.BANANID == BanAnID
                                                                && x.TOIDANHID == toidanhid
                                                            ).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                if (obj != null)
                    isupdate = true;
                else
                    obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET(); }
            if (!isupdate)
            {
                obj.BICANID = BiCanID;
                obj.VUANID = VuAnID;
                obj.BANANID = BanAnID;
                obj.DIEULUATID = Convert.ToDecimal(dropBoLuat.SelectedValue);
                obj.TOIDANHID = toidanhid;
                obj.HINHPHATID = obj.LOAIHINHPHAT = obj.ISCHANGE = 0;
                obj.TENTOIDANH = tentoidanh; //dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).FirstOrDefault().TENTOIDANH;
                dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
            }
        }
        
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        public void LoadGrid()
        {
            int hieuluc = 1;
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            
            string tentoidanh = txtTenToiDanh.Text.Trim();
            string diem = txtDiem.Text.Trim();
            string khoan = txtKhoan.Text.Trim();
            string dieu = txtDieu.Text.Trim();
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByLuatID_NoChuong_Paging(luatid, tentoidanh, diem, khoan, dieu, hieuluc, pageindex, pagesize);

            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
                //lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
                GetOldChange();
            }
            else
            {
                pndata.Visible = false;
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }
        void GetOldChange()
        {
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            string OldChange = "|";
            string temp = "|";
            List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = null;
            lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID
                                                          && x.BANANID == BanAnID).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
            if (lst != null && lst.Count > 0)
            {
                foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET obj in lst)
                    OldChange += obj.DIEULUATID + ";" + obj.TOIDANHID + "|";
                hddOld.Value = OldChange;
            }
            else
            {
                //Lay ds cac toi danh cho bi cao tu cao trang sang
                List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lstToiDanhCT = null;
                lstToiDanhCT = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID 
                                                                        && x.BICANID == BiCanID).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                if (lstToiDanhCT != null && lstToiDanhCT.Count>0)
                {
                    foreach (AHS_SOTHAM_BANAN_DIEU_CHITIET obj in lstToiDanhCT)
                        OldChange += obj.DIEULUATID + ";" + obj.TOIDANHID + "|";
                    hddOld.Value = OldChange;
                }
            }
            //----------------------
            if (OldChange != "|")
            {
                foreach (RepeaterItem item in rpt.Items)
                {
                    CheckBox chk = (CheckBox)item.FindControl("chk");
                    HiddenField hddBoLuatID = (HiddenField)item.FindControl("hddBoLuatID");
                    HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                    temp = "|" + hddBoLuatID.Value + ";" + hddToiDanhID.Value + "|";
                    if (hddOld.Value.Contains(temp))
                        chk.Checked = true;
                    else chk.Checked = false;
                }
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //Panel pnChonHinhPhat = (Panel)e.Item.FindControl("pnChonHinhPhat");
                //HiddenField hddToiDanhID = (HiddenField)e.Item.FindControl("hddToiDanhID");
                //decimal curr_toidanh = Convert.ToDecimal(hddToiDanhID.Value);
                //List<AHS_SOTHAM_BANAN_DIEU_CHITIET> lst = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BANANID == BanAnID
                //                                                                                   && x.BICANID == BiCaoID
                //                                                                                   && x.TOIDANHID == curr_toidanh
                //                                                                                 ).ToList<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                //if (lst != null && lst.Count > 0)
                //    pnChonHinhPhat.Visible = true;
                //else
                //    pnChonHinhPhat.Visible = false;
            }
        }
        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
    }
}