using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebRole.Models
{
    public class RelatedNameResult
    {
        public string Name { get; set; }
        public int Count { get; set; }
        public int Sum { get; set; }
        public int MaleCount { get; set; }
        public int FemaleCount { get; set; }


        public bool IsMale
        {
            get { return MaleCount > 3  *FemaleCount; }
        }

        public bool IsFemale
        {
            get { return FemaleCount > 3 * MaleCount; }
        }

        public bool IsUnknown
        {
            get { return FemaleCount < 2 && MaleCount < 2; }
        }

        public bool IsUnisex
        {
            get { return !IsMale && !IsFemale && !IsUnknown; }
        }

        public string GenderClass 
        {
            get
            {
                if (IsUnknown) return "unknown";
                if (IsMale) return "male";
                if (IsFemale) return "female";
                if (IsUnisex) return "unisex";

                return "unknown"; // should not reach this
            }
        }
    }
}