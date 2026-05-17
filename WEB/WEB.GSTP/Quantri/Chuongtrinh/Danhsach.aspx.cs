using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.IO;

namespace WEB.GSTP.Quantri.Chuongtrinh
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {

                   
                    List<QT_HETHONG> list = dt.QT_HETHONG.OrderBy(x => x.THUTU).ToList();
                    FillThutu(list.Count);
                    if (list.Count > 0)
                    {
                        dropThutu.SelectedIndex = dropThutu.Items.Count - 1;
                    }

                    objSubSite();
                    lblmgs.Text = "";
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.TAOMOI);
                   
                }
            }
            catch (Exception ex)
            {
                lblmgs.Text = ex.Message;
            }
        }

        private void objSubSite()
        {

            try
            {
                List<QT_HETHONG> lst = dt.QT_HETHONG.OrderBy(x => x.THUTU).ToList();

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(lst.Count, 20).ToString();

                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + lst.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                #endregion

                dgrDanhMucCT.DataSource = lst;
                dgrDanhMucCT.DataBind();
              

            }
            catch (Exception ex)
            {
                lblmgs.Text = ex.Message;
            }
        }

        private void FillThutu(int iCount)
        {
            dropThutu.Items.Clear();
            for (int i = 1; i <= iCount + 1; i++)
            {
                dropThutu.Items.Add(new ListItem(i.ToString(), i.ToString()));
            }
        }

        protected void btnHuyCapNhat_Click(object sender, EventArgs e)
        {
            // hddchuongtrinhID.Value = "0";

            Laydulieu();
        }

        private void updatedata()
        {
            if (!string.IsNullOrEmpty(hddchuongtrinhID.Value))
            {
                int chuongtrinhid = 0;
                if (Int32.TryParse(hddchuongtrinhID.Value, out chuongtrinhid))
                {
                    if (chuongtrinhid != 0)
                    {

                        QT_HETHONG otblCT = dt.QT_HETHONG.Where(x=>x.ID==chuongtrinhid).FirstOrDefault();
                        if (otblCT == null) return;
                        hddchuongtrinhID.Value = otblCT.ID.ToString();
                        otblCT.MA = txtMaChuongTrinh.Text.ToUpper();
                        otblCT.TEN = txtTenChuongTrinh.Text;
                        otblCT.LOAI = Convert.ToInt32(ddlLoai.SelectedItem.Value);
                        otblCT.THUTU = Convert.ToInt32(dropThutu.SelectedItem.Value);
                        otblCT.LINKURL = txtURL.Text;
                        //if (hddFilePath.Value != "")
                        //{
                        //    try
                        //    {
                        //        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        //        byte[] buff = null;
                        //        using (FileStream fs = File.OpenRead(strFilePath))
                        //        {
                        //            BinaryReader br = new BinaryReader(fs);
                        //            FileInfo oF = new FileInfo(strFilePath);
                        //            long numBytes = oF.Length;
                        //            buff = br.ReadBytes((int)numBytes);
                        //            otblCT.IMAGE = buff;      
                        //        }
                        //        File.Delete(strFilePath);
                        //    }
                        //    catch (Exception ex) {}
                        //}
                        dt.SaveChanges();

                    }

                }
            }

        }

        protected void btnCapNhat_Click(object sender, EventArgs e)
        {
            if (txtMaChuongTrinh.Text.Trim().ToString() == "" || txtMaChuongTrinh.Text.Trim().ToString() == null)
            {
                lblmgs.Text = "Bạn hãy nhập mã chương trình!";
                return;
            }
            if (txtTenChuongTrinh.Text.Trim().ToString() == "" || txtTenChuongTrinh.Text.Trim().ToString() == null)
            {
                lblmgs.Text = "Bạn hãy nhập tên chương trình!";
                return;
            }

            if (hddchuongtrinhID.Value != "0")
            {
                int chuongtrinhid = Convert.ToInt32(hddchuongtrinhID.Value);
                QT_HETHONG otblCT = dt.QT_HETHONG.Where(x => x.ID == chuongtrinhid).FirstOrDefault();               
                if (otblCT == null) return;
                List<QT_HETHONG> list = dt.QT_HETHONG.Where(x => x.MA == txtMaChuongTrinh.Text).ToList();
                List<QT_HETHONG> listten = dt.QT_HETHONG.Where(x => x.TEN == txtTenChuongTrinh.Text).ToList();
               
                if (list.Count >= 1 && otblCT.MA != txtMaChuongTrinh.Text.Trim().ToUpper())
                {
                    lblmgs.Text = "Mã chương trình này đã tồn tại, vui lòng chọn mã chương trình khác!";
                    txtMaChuongTrinh.Focus();
                }
                else
                {
                    if (listten.Count >= 1 && otblCT.TEN.Trim().ToUpper() != txtTenChuongTrinh.Text.Trim().ToUpper())
                    {
                        lblmgs.Text = "Tên chương trình này đã tồn tại!";
                        txtTenChuongTrinh.Focus();
                    }
                    else
                    {                       
                        updatedata();
                        btnLammoi_Click(sender, e);
                        lblmgs.Text = "Lưu thành công!";
                        objSubSite();
                    }
                }

            }
            else
            {
                List<QT_HETHONG> list = dt.QT_HETHONG.Where(x => x.MA == txtMaChuongTrinh.Text).ToList();
                List<QT_HETHONG> listten = dt.QT_HETHONG.Where(x => x.TEN == txtTenChuongTrinh.Text).ToList();

                if (list.Count > 0)
                {
                    lblmgs.Text = "Mã chương trình này đã tồn tại, vui lòng chọn mã chương trình khác!";
                    txtMaChuongTrinh.Focus();
                }
                else
                {
                    if (listten.Count > 0)
                    {
                        lblmgs.Text = "Tên chương trình này đã tồn tại!";
                    }
                    else
                    {
                        QT_HETHONG otblCT = new QT_HETHONG();
                        otblCT.MA = txtMaChuongTrinh.Text.ToUpper();
                        otblCT.TEN = txtTenChuongTrinh.Text;
                        otblCT.THUTU = Convert.ToInt32(dropThutu.SelectedValue);
                        otblCT.LOAI = Convert.ToInt32(ddlLoai.SelectedItem.Value);
                        otblCT.LINKURL = txtURL.Text;
                        //if (hddFilePath.Value != "")
                        //{
                        //    try
                        //    {
                        //        string strFilePath = hddFilePath.Value.Replace("/", "\\");
                        //        byte[] buff = null;
                        //        using (FileStream fs = File.OpenRead(strFilePath))
                        //        {
                        //            BinaryReader br = new BinaryReader(fs);
                        //            FileInfo oF = new FileInfo(strFilePath);
                        //            long numBytes = oF.Length;
                        //            buff = br.ReadBytes((int)numBytes);
                        //            otblCT.IMAGE = buff;
                        //        }
                        //        File.Delete(strFilePath);
                        //    }
                        //    catch (Exception ex) { }
                        //}
                        dt.QT_HETHONG.Add(otblCT);
                        dt.SaveChanges();
                        //Sau khi insert du lieu thì phải load lại dropthutu

                        List<QT_HETHONG> lstC = dt.QT_HETHONG.OrderBy(x => x.THUTU).ToList();
                        FillThutu(lstC.Count);
                        dropThutu.SelectedIndex = dropThutu.Items.Count - 1;
                        //dông thời load lại data vào datagrid
                        objSubSite();
                        btnLammoi_Click(sender, e);
                        lblmgs.Text = "Thêm mới thành công!";
                    }
                }
            }


        }

        //Khi lấy dữ liệu của đối tượng theo id của nó. dùng khi click nút xóa thì dl được load lên các điều khiển
        private void Laydulieu()
        {
            try
            {
                QT_HETHONG otblCT;
                if (!string.IsNullOrEmpty(hddchuongtrinhID.Value))
                {
                    int chuongtrinhid = 0;
                    if (Int32.TryParse(hddchuongtrinhID.Value, out chuongtrinhid))
                    {
                        if (chuongtrinhid != 0)
                        {
                            otblCT = dt.QT_HETHONG.Where(x => x.ID == chuongtrinhid).FirstOrDefault();

                            hddchuongtrinhID.Value = otblCT.ID.ToString();
                            txtMaChuongTrinh.Text = otblCT.MA;
                            txtTenChuongTrinh.Text = otblCT.TEN;
                            txtURL.Text = otblCT.LINKURL;
                            string h = otblCT.THUTU.ToString();
                            dropThutu.SelectedValue = otblCT.THUTU.ToString();
                            if (otblCT.LINKURL != "")
                            {
                                string str = Convert.ToBase64String(otblCT.IMAGE);
                                imageSRC.Src = "~/UI/img/"+otblCT.LINKURL;
                            }
                            else
                                imageSRC.Src = "";

                        }
                    }

                }
            }
            catch (Exception ex)
            {
                lblmgs.Text = ex.Message;
            }


        }

        protected void dgrDanhMucCT_ItemCommand(object o, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));           
            
                int chuongtrinhID = Convert.ToInt32(e.CommandArgument);
                switch (e.CommandName)
                {
                    case "xoa":
                    if (oPer.XOA == false)
                    {
                        lblmgs.Text = "Bạn không có quyền Lưu!";
                        return;
                    }
                    lblmgs.Text = "";
                        // Kiểm tra xem dữ liệu đang sử dụng hay ko, nếu đang sử dụng trong danh mục menu thì ko được phép xóa
                        List<QT_CHUONGTRINH> list = dt.QT_CHUONGTRINH.Where(x => x.HETHONGID == chuongtrinhID).ToList();
                        if (list.Count > 0)
                        {
                            lblmgs.Text = "Chương trình đang được sử dụng, không thể xóa!";
                        }
                        else
                        {
                            QT_HETHONG otblCT = dt.QT_HETHONG.Where(x => x.ID == chuongtrinhID).FirstOrDefault();
                            dt.QT_HETHONG.Remove(otblCT);
                            dgrDanhMucCT.CurrentPageIndex = 0;
                            resetcontrol();
                            lblmgs.Text = "Xóa dữ liệu thành công! ";
                            objSubSite();
                        }

                        break;

                    case "sua":
                        try
                        {
                            //Ma chuong trinh ko duoc phep sua;
                            txtMaChuongTrinh.Enabled = false;
                            lblmgs.Text = "";
                            hddchuongtrinhID.Value = Convert.ToString(e.CommandArgument);

                            Laydulieu();

                        }
                        catch (Exception ex)
                        { lblmgs.Text = ex.Message; }

                        break;

                }
          



        }

        //protected void AsyncFileUpLoad_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        //{
        //    if (AsyncFileUpLoad.HasFile)
        //    {
        //        string strFileName = AsyncFileUpLoad.FileName;
        //        string path = Server.MapPath("~/TempUpload/") + strFileName;
        //        AsyncFileUpLoad.SaveAs(path);

        //        path = path.Replace("\\", "/");
        //        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "filePath", "top.$get(\"" + hddFilePath.ClientID + "\").value = '" + path + "';", true);
        //    }
        //}

        private void resetcontrol()
        {
            lblmgs.Text = "";
            txtTenChuongTrinh.Text = "";
            txtMaChuongTrinh.Text = "";
           
            txtMaChuongTrinh.Enabled = true;
        }

        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            lblmgs.Text = "";
            txtTenChuongTrinh.Text = "";
            txtMaChuongTrinh.Enabled = true;
            txtMaChuongTrinh.Text = "";
          
            hddchuongtrinhID.Value = "0";
        }

        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgrDanhMucCT.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            objSubSite();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgrDanhMucCT.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            objSubSite();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgrDanhMucCT.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            objSubSite();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgrDanhMucCT.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            objSubSite();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgrDanhMucCT.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            objSubSite();
        }

        #endregion
    }
}
