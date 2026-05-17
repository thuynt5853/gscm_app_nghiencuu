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

namespace WEB.GSTP.QLAN.AHS.SoTham.Popup
{
    public partial class pChonToiDanh : System.Web.UI.Page
    {

        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal VuAnID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                VuAnID = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
                if (VuAnID>0)
                {
                    LoadDrop();
                    try
                    {
                        if (Request["bID"] != null)
                            dropBiCao.SelectedValue = Request["bID"] + "";
                    }
                    catch { }
                    CheckQuyen();
                    LoadGrid();
                }
                else
                    Response.Redirect("/Login.aspx");
            }
        }
        void CheckQuyen()
        {
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            int MAGIAIDOAN = Convert.ToInt16(oT.MAGIAIDOAN);
            if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.DINHCHI)
            {
                lbthongbao.Text = "Vụ việc đã bị đình chỉ, không được sửa đổi !";
                cmdSave.Visible = cmdSave2.Visible = false;
                return;
            }
            else if (MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.PHUCTHAM || MAGIAIDOAN == (int)ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                cmdSave.Visible = cmdSave2.Visible = false;
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
                
            }
            //--------------------------
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
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        void GetOldChange()
        {
            string OldChange = "|";
            string temp = "|";
            Decimal VuAnID = (String.IsNullOrEmpty(Request["hsID"] + "")) ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            Decimal bicanid = Convert.ToDecimal(dropBiCao.SelectedValue); //(String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");

            //decimal caotrangid = Convert.ToDecimal(Request["cID"] + "");
            List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = null;
            lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bicanid 
                                                          && x.VUANID == VuAnID).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
            if (lst != null && lst.Count>0)
            {
                foreach(AHS_SOTHAM_CAOTRANG_DIEULUAT obj in lst)
                    OldChange += obj.DIEULUATID + ";" + obj.TOIDANHID + "|";
                hddOld.Value = OldChange;
                //----------------------
                foreach (RepeaterItem item in rpt.Items)
                {
                        CheckBox chk = (CheckBox)item.FindControl("chk");
                        HiddenField hddBoLuatID = (HiddenField)item.FindControl("hddBoLuatID");
                        HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
                        temp = "|" + hddBoLuatID.Value +";" + hddToiDanhID.Value + "|";
                    if (hddOld.Value.Contains(temp))
                        chk.Checked = true;
                    else chk.Checked = false;                
                }
            }
        }
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            String OldChange = hddOld.Value;
            string temp = "";
            String DelItem = "|";
            foreach(RepeaterItem item in rpt.Items)
            {
                CheckBox chk = (CheckBox)item.FindControl("chk");
                HiddenField hddBoLuatID = (HiddenField)item.FindControl("hddBoLuatID");
                HiddenField hddToiDanhID = (HiddenField)item.FindControl("hddToiDanhID");
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
                            ThemMoi(hddBoLuatID.Value, hddToiDanhID.Value);
                    }
                }
                else
                {
                    if (chk.Checked)
                        ThemMoi(hddBoLuatID.Value, hddToiDanhID.Value);
                }
            }
            //---------------------------------------
            if ((!string.IsNullOrEmpty(DelItem)) && (DelItem != "|"))
                XoaItem(DelItem);

            //---------------------------------------
            // lbthongbao.Text = "Lưu quyết định cho bị can: "+ dropBiCao.SelectedItem.Text + " thành công!";
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
        void XoaItem(string DelItem)
        {
            decimal bicanid = Convert.ToDecimal(dropBiCao.SelectedValue);
            VuAnID = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            decimal boluatid = 0, toidanhid = 0;
            string[] arr_child = null;
            string[] arr = DelItem.Split("|".ToArray());

            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = null;
            foreach (String item in arr)
            {
               if (item.Length > 0)
               {
                    arr_child = item.Split(";".ToCharArray());
                    boluatid = Convert.ToDecimal(arr_child[0] + "");
                    toidanhid = Convert.ToDecimal(arr_child[1] + "");

                    List<AHS_SOTHAM_CAOTRANG_DIEULUAT> lst = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == bicanid
                                                                                                      && x.VUANID == VuAnID
                                                                                                      && x.DIEULUATID == boluatid
                                                                                                      && x.TOIDANHID == toidanhid
                                                                                                  ).ToList<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                    if (lst.Count > 0)
                    {
                        obj = lst.Single<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                        dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
                        dt.SaveChanges();
                    }
                }
            }
        }
        void ThemMoi(string strboluatid, string strtoidanhid)
        {
            VuAnID = String.IsNullOrEmpty(Request["hsID"] + "") ? 0 : Convert.ToDecimal(Request["hsID"] + "");
            Decimal boluatid = Convert.ToDecimal(strboluatid);
            decimal toidanhid = Convert.ToDecimal(strtoidanhid);
            decimal bicanid = Convert.ToDecimal(dropBiCao.SelectedValue);
            
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
                        InsertToiDanh(bicanid, VuAnID, toidanhid);
                    }
                }
                dt.SaveChanges();
            }
        }
        void InsertToiDanh(Decimal BiCanID, Decimal VuAnID, Decimal toidanhid)
        {
            bool isupdate = false;
            DM_BOLUAT_TOIDANH objTD = null;
            AHS_SOTHAM_CAOTRANG_DIEULUAT obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            try
            {
                obj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == BiCanID
                                                                && x.VUANID == VuAnID
                                                                && x.TOIDANHID == toidanhid
                                                            ).Single<AHS_SOTHAM_CAOTRANG_DIEULUAT>();
                if (obj != null)
                    isupdate = true;
                else
                    obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_CAOTRANG_DIEULUAT(); }
            if (!isupdate)
            {
                obj.BICANID = BiCanID;
                obj.CAOTRANGID = 0;
                obj.VUANID = VuAnID;
                obj.DIEULUATID = Convert.ToDecimal(dropBoLuat.SelectedValue);
                obj.TOIDANHID = toidanhid;

                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                objTD = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == toidanhid).Single();
                obj.TENTOIDANH = objTD.TENTOIDANH;
                obj.ISMAIN = 0;
                // insert toa_gq_id
                if (obj.TOA_GIAIQUYET_ID == null)
                {
                    obj.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                }
                dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Add(obj);
            }
        }


        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
            //Response.Redirect("DieuLuatAD.aspx?bID=" + Request["bID"].ToString() + "&cID=" + Request["cID"].ToString());
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
            string tentoidanh = txtTenToiDanh.Text.Trim();
            int hieuluc = 1;
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
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