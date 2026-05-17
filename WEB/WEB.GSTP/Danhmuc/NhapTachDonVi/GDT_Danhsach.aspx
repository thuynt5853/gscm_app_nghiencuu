<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="GDT_Danhsach.aspx.cs" Inherits="WEB.GSTP.Danhmuc.NhapTachDonVi.GDT_Danhsach" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="80" runat="server" />

    <asp:HiddenField ID="hddTotalPageN" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndexN" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSizeN" Value="80" runat="server" />
    <style type="text/css">
        .btnTimKiemCss {
            margin-left: 5px;
        }
    </style>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td style="width: 100%; vertical-align: top; text-align: left">
                            <table style="width: 100%; padding: 3px; border-spacing: 3px;">
                               
                                <tr>
                                    <td style="width: 100px;">Đơn vị<asp:Label runat="server" ID="nhap" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td colspan ="3">
                                        <asp:DropDownList ID="ddlToaAn" CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="true" OnSelectedIndexChanged="ddlToaAn_SelectedIndexChanged"></asp:DropDownList></td>
                                </tr>
                                <tr style="display:none">
                                    <td>
                                        Hiệu lực
                                    </td>
                                    <td colspan ="3">
                                        <asp:CheckBox ID="chkActive" class="check" runat="server" Checked ="true"  AutoPostBack="true" OnCheckedChanged="lbtActive_Click"   Visible="false"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 100px;">Tên phòng chuyển dữ liệu<asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td style="width: 260px;">
                                        <asp:DropDownList ID="ddlPhongChuyen" CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="true" OnSelectedIndexChanged="ddlPhongChuyen_SelectedIndexChanged"></asp:DropDownList>
                                    </td>

                                    <td style="width: 100px;">Tên phòng nhận dữ liệu<asp:Label runat="server" ID="Label1" Text="(*)" ForeColor="Red"></asp:Label></td>
                                    <td>
                                        <asp:DropDownList ID="ddlPhongNhan" CssClass="chosen-select" runat="server" Width="230px" AutoPostBack="true" OnSelectedIndexChanged="ddlPhongNhan_SelectedIndexChanged"></asp:DropDownList>
                                    </td>
                                </tr>  
                                
                               <tr>
                                   <td>Lĩnh vực</td>
                                   <td>
                                       <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>                                    
                                   </td>
                                   <td>Lĩnh vực</td>
                                   <td >
                                       <asp:DropDownList ID="ddlLoaiAn_Nhan" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_Nhan_SelectedIndexChanged"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>                                    
                                   </td>
                               </tr>
                                  <tr>
                                      <td>Số BA/QĐ</td>
                                      <td>
                                          <asp:TextBox ID="txtSoBA" CssClass="user" runat="server"  Width="225px" MaxLength="230"></asp:TextBox>                                  
                                      </td>
                                      <td>Ghi chú</td>
                                      <td>
                                            <asp:TextBox ID="txtGhichu" CssClass="user" runat="server"  Width="225px" MaxLength="230"></asp:TextBox>
                                      </td>
                                  </tr>
                                  <tr>
                                      <td>Ngày BA/QĐ</td>
                                      <td colspan ="3">
                                          <asp:TextBox ID="txtNgayBA" runat="server" CssClass="user" Width="225px" MaxLength="10"></asp:TextBox>
                                          <cc1:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtNgayBA" Format="dd/MM/yyyy" Enabled="true" />
                                          <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtNgayBA" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                      </td>
                                  </tr>  
                                <tr>
                                    <td>Kết quả giải quyết</td>
                                    <td colspan ="3">
                                        <asp:DropDownList ID="ddlKetquaThuLy" CssClass="chosen-select"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaThuLy_SelectedIndexChanged"
                                            runat="server" Width="230px">
                                            <%--<asp:ListItem Value="3" Text="--Tất cả--"></asp:ListItem>--%>
                                            <asp:ListItem Value="4" Selected="True" Text="Chưa có kết quả "></asp:ListItem>
                                            <asp:ListItem Value="5" Text="Đã có kết quả"></asp:ListItem>
                                            <asp:ListItem Value="7" Text="Đã có KQ nhưng vẫn còn đơn TLM"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="...Trả lời đơn"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="......Kháng nghị (CA)"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="...Xếp đơn"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="...VKS đang giải quyết"></asp:ListItem>
                                                <asp:ListItem Value="6" Text="...Xử lý khác"></asp:ListItem>
                                            <asp:ListItem Value="11" Text="...Trả lời đơn + Kháng nghị (CA)"></asp:ListItem>
                                            <asp:ListItem Value="12" Text="...Trả lời đơn + Xếp đơn"></asp:ListItem>
                                            <asp:ListItem Value="13" Text="...Trả lời đơn + Xử lý khác"></asp:ListItem>
                                            <asp:ListItem Value="14" Text="...Kháng nghị (CA) + Xếp đơn"></asp:ListItem>
                                            <asp:ListItem Value="15" Text="...Kháng nghị (CA) + Xử lý khác"></asp:ListItem>
                                            <asp:ListItem Value="16" Text="Chưa có kết quả xét xử GDTT"></asp:ListItem>
                                            <asp:ListItem Value="17" Text="Đã có kết quả xét xử GDTT"></asp:ListItem>

                                        </asp:DropDownList>
                                    </td>
                                    
                                </tr>  
                                <tr>
                                    <td>Lý do chuyển dữ liệu</td>
                                    <td colspan ="3">
                                        <asp:DropDownList ID="ddlLyDo" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>   
                                    </td>
                                </tr>  
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="btnTimKiem" runat="server" CssClass="buttoninput" Text="Tìm Kiếm" OnClick="btnTimKiem_Click"    OnClientClick="return validate_search();"  />
                                         <asp:Button ID="cmdChuyenDL" runat="server" CssClass="buttoninput" Text="Chuyển Dữ Liệu" OnClick="btnChuyenDL_Click"  OnClientClick="return validate();"  />
                                    </td>
                                </tr>
                                <tr><td colspan ="4">
                                     <div style="margin: 5px; text-align: center; width: 95%; color: red; font-size: 13px;">
                                        <asp:Label ID="lstMsgT" Font-Size="17px" runat="server"></asp:Label>
                                    </div></td>
                                </tr>
                                <tr><td colspan ="2" style="width: 600px;font-weight:bold;font-size:20px; padding-top:20px">Dữ liệu chuyển</td>
                                    <td colspan ="2" style="font-weight:bold;font-size:20px; padding-top:20px">Dữ liệu nhận</td></tr>
                                 <tr>
                                    
                                    <td colspan="2" style="vertical-align: top;">
                                        <div class="phantrang">
                                            <div class="sobanghi">
                                
                                                <asp:Literal ID="lstSobanghiT" runat="server" ></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNext_Click"></asp:LinkButton>
                                                <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                                    AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                                    <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                    <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                   <HeaderTemplate>
                                                        <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAll_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%--<asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("ID")%>' />--%>
                                                        <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                                        <!----------------------------------------->
                                                         <%-- CheckHS: <%#Eval("CheckHoSo")%>--%>
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdSoDonTrung" runat="server" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung" ></asp:LinkButton>
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                            Visible='<%# (Eval("IsAnQuocHoi")+"")=="0"?false:true  %>' ></asp:LinkButton>
                                                         <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án chỉ đạo"  %>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="CHIDAO"
                                                            Visible='<%# (Eval("IsAnChiDao")+"")=="0"?false:true  %>'></asp:LinkButton>                                            
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn  ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                                    <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("InforBA")%>                                                       
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>   <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="100px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="100px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="150px"></asp:BoundColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Trạng thái</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b><asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                                        <br />
                                                        <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                                         <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                                           <asp:Literal ID="lttOther" runat="server" Visible ="false"></asp:Literal>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người tạo</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("NGUOITAO") %><br />
                                                        <i><%#Eval("NGAYTAO") %></i>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>

                                        <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_ItemDataBound">
                                            <Columns>
                                                <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>
                                                        <asp:CheckBox ID="chkChonAll" AutoPostBack="true" OnCheckedChanged="chkChonAllHS_CheckChange" ToolTip="Chọn tất cả" runat="server" />
                                                    </HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%--<asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("ID")%>' />--%>
                                                        <asp:CheckBox ID="chkChon" ToolTip='<%#Eval("ID")%>' runat="server" />
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                                    <ItemTemplate>
                                                         <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                                        <!----------------------------------------->                                                        
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdSoDonTrung" runat="server" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung" ></asp:LinkButton>
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                            Visible='<%# (Eval("IsAnQuocHoi")+"")=="0"?false:true  %>' ></asp:LinkButton>
                                                         <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án chỉ đạo"  %>'
                                                            CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                            Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>'></asp:LinkButton>                                            
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn  ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                                    <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("InforBA")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>   
                                                 <asp:BoundColumn DataField="QHPLDN" HeaderText="Tội danh" HeaderStyle-Width="120px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="70px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="70px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người khiếu nại" HeaderStyle-Width="90px"></asp:BoundColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Trạng thái</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b><asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                                        <br />
                                                        <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                                         <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                                           <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>  
                                                <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người tạo</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("NGUOITAO") %><br />
                                                        <i><%#Eval("NGAYTAO") %></i>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                        <div class="phantrang">
                                            
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNext_Click"></asp:LinkButton>
                                                <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                                    <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                    <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </td>
                                     <%--Du lieu nhận được--%>
                                    <td colspan ="2" style="vertical-align: top;">
                                         <div class="phantrang">
                                            <div class="sobanghi">
                                
                                                <asp:Literal ID="lstSobanghiNhan" runat="server" ></asp:Literal>
                                            </div>
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbTBackN" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBack_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTFirstN" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirstN_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep1N" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTStep2N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep3N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep4N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTStep5N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:Label ID="lbTStep6N" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbTLastN" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLastN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbTNextN" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNextN_Click"></asp:LinkButton>
                                                <asp:DropDownList ID="ddlPageCountN" runat="server" Width="55px" CssClass="so" Visible="false"
                                                    AutoPostBack="True" OnSelectedIndexChanged="ddlPageCountN_SelectedIndexChanged">
                                                    <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                    <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                        <asp:DataGrid ID="dgList_Nhan" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_Nhan_ItemDataBound">
                                            <Columns>
                                               
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                                        <!----------------------------------------->
                                                         <%-- CheckHS: <%#Eval("CheckHoSo")%>--%>
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdSoDonTrung" runat="server" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung" ></asp:LinkButton>
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                            Visible='<%# (Eval("IsAnQuocHoi")+"")=="0"?false:true  %>' ></asp:LinkButton>
                                                         <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án chỉ đạo"  %>'
                                                            CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                            Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>'></asp:LinkButton>                                            
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn  ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                                    <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("InforBA")%>                                                       
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>   <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="100px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="100px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="150px"></asp:BoundColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Trạng thái</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b><asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                                        <br />
                                                        <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                                         <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                                           <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn> 
                                                <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người tạo</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("NGUOITAO") %><br />
                                                        <i><%#Eval("NGAYTAO") %></i>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>

                                        <asp:DataGrid ID="dgList_Nhan_HS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                            PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                            CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                            ItemStyle-CssClass="chan" Width="100%" OnItemDataBound="dgList_Nhan_ItemDataBound">
                                            <Columns>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                                    <ItemTemplate>
                                                         <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                                        <!----------------------------------------->                                                        
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdSoDonTrung" runat="server" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung" ></asp:LinkButton>
                                                        <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"%>'
                                                            CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                            Visible='<%# (Eval("IsAnQuocHoi")+"")=="0"?false:true  %>' ></asp:LinkButton>
                                                         <br style="margin-top: 10px;" />
                                                        <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" 
                                                            ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án chỉ đạo"  %>'
                                                            CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                            Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>'></asp:LinkButton>                                            
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn  ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                                    <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("InforBA")%>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>   
                                                 <asp:BoundColumn DataField="QHPLDN" HeaderText="Tội danh" HeaderStyle-Width="120px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="70px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="70px"></asp:BoundColumn>
                                                <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người khiếu nại" HeaderStyle-Width="90px"></asp:BoundColumn>
                                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Trạng thái</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <b><asp:Literal ID="lttLanTT" runat="server"></asp:Literal></b>
                                                        <br />
                                                        <asp:Literal ID="lttDetaiTinhTrang" runat="server"></asp:Literal>
                                                         <asp:Literal ID="lttKQGQ" runat="server"></asp:Literal>
                                                           <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                                    </ItemTemplate>
                                                </asp:TemplateColumn>
                                                <asp:TemplateColumn HeaderStyle-Width="70px" HeaderStyle-HorizontalAlign="Center">
                                                    <HeaderTemplate>Người tạo</HeaderTemplate>
                                                    <ItemTemplate>
                                                        <%#Eval("NGUOITAO") %><br />
                                                        <i><%#Eval("NGAYTAO") %></i>
                                                    </ItemTemplate>
                                                    <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                </asp:TemplateColumn>
                                            </Columns>
                                            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                            <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                        </asp:DataGrid>
                                      <div class="phantrang">
                                           
                                            <div class="sotrang">
                                                <asp:LinkButton ID="lbBBackN" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                                    OnClick="lbTBackN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBFirstN" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                                    Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep1N" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBStep2N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="2" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep3N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="3" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep4N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="4" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBStep5N" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="5" OnClick="lbTStepN_Click"></asp:LinkButton>
                                                <asp:Label ID="lbBStep6N" runat="server" Text="..." Visible="false"></asp:Label>
                                                <asp:LinkButton ID="lbBLastN" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                                    Text="100" OnClick="lbTLastN_Click"></asp:LinkButton>
                                                <asp:LinkButton ID="lbBNextN" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                                    OnClick="lbTNextN_Click"></asp:LinkButton>
                                                <asp:DropDownList ID="ddlPageCount2N" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                                    <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                                    <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                                    <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                                    <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                                    <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                                    <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                                </asp:DropDownList>
                                            </div>
                                        </div>
                                    </td>
                                 </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">

      
        function pageLoad(sender, args) { 
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function validate_search() {
            var ddlToaAn = document.getElementById('<%=ddlToaAn.ClientID%>');
             var vddlToaAn = ddlToaAn.options[ddlToaAn.selectedIndex].value;
             if (vddlToaAn == 0) {
                 alert('Bạn chưa chọn Đơn vị chuyển');
                 return false;
             }

             var ddlPhongChuyen = document.getElementById('<%=ddlPhongChuyen.ClientID%>');
            var vPhongChuyen = ddlPhongChuyen.options[ddlPhongChuyen.selectedIndex].value;
            if (vPhongChuyen == 0) {
                alert('Bạn chưa chọn Phòng chuyển dữ liệu');
                return false;
            }

            var ddlLoaiAn = document.getElementById('<%=ddlLoaiAn.ClientID%>');
            var vddlLoaiAn = ddlLoaiAn.options[ddlLoaiAn.selectedIndex].value;
            if (vddlLoaiAn == 0) {
                alert('Bạn chưa chọn Loại án');
                return false;
            }

            var ddlPhongNhan = document.getElementById('<%=ddlPhongNhan.ClientID%>');
            var vPhongNhan = ddlPhongNhan.options[ddlPhongNhan.selectedIndex].value;
            if (vPhongNhan == 0) {
                alert('Bạn chưa chọn Phòng nhận dữ liệu');
                return false;
            }
            if (vPhongChuyen == vPhongNhan) {
                alert('Phòng nhận dữ liệu phải khác Phòng chuyển dữ liệu');
                return false;
            }

            return true;
         }
        function validate() {
            var ddlToaAn = document.getElementById('<%=ddlToaAn.ClientID%>');
            var vddlToaAn = ddlToaAn.options[ddlToaAn.selectedIndex].value;
            if (vddlToaAn == 0) {
                alert('Bạn chưa chọn Đơn vị chuyển');
                return false;
            } 

            var ddlPhongChuyen = document.getElementById('<%=ddlPhongChuyen.ClientID%>');
            var vPhongChuyen = ddlPhongChuyen.options[ddlPhongChuyen.selectedIndex].value;
            if (vPhongChuyen == 0) {
                alert('Bạn chưa chọn Phòng chuyển dữ liệu');
                return false;
            }

            var ddlLoaiAn = document.getElementById('<%=ddlLoaiAn.ClientID%>');
            var vddlLoaiAn = ddlLoaiAn.options[ddlLoaiAn.selectedIndex].value;
            if (vddlLoaiAn == 0) {
                alert('Bạn chưa chọn Loại án sẽ chuyển');
                return false;
            }


            var ddlLyDo = document.getElementById('<%=ddlLyDo.ClientID%>');
            var vddlLyDo = ddlLyDo.options[ddlLyDo.selectedIndex].value;
            if (vddlLyDo == 0) {
                alert('Bạn chưa chọn Lý do chuyển dữ liệu');
                return false;
            }

            var ddlPhongNhan = document.getElementById('<%=ddlPhongNhan.ClientID%>');
            var vPhongNhan = ddlPhongNhan.options[ddlPhongNhan.selectedIndex].value;
            if (vPhongNhan == 0) {
                alert('Bạn chưa chọn Phòng nhận dữ liệu');
                return false;
            }
            if (vPhongChuyen == vPhongNhan)
            {
                alert('Phòng nhận dữ liệu phải khác Phòng chuyển dữ liệu');
                return false;
            }
            var ddlLoaiAn_Nhan = document.getElementById('<%=ddlLoaiAn_Nhan.ClientID%>');
            var vddlLoaiAn_Nhan = ddlLoaiAn_Nhan.options[ddlLoaiAn_Nhan.selectedIndex].value;
            if (vddlLoaiAn_Nhan != vddlLoaiAn) {
                alert('Loại án sẽ chuyển phải tương ứng với Loại án của đơn vị nhận');
                return false;
            }

            return true;
        }
    </script>
</asp:Content>
