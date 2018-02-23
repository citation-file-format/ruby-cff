# Copyright (c) 2018 Robert Haines.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
module CFF

  # Utility methods useful throughout the rest of the CFF library.
  module Util

    # :call-seq:
    #   delete_from_hash(hash, keys...) -> Hash
    #
    # Returns a hash that includes everything but the given keys.
    def delete_from_hash(hash, *keys)
      h = hash.dup
      keys.each { |key| h.delete(key) }
      h
    end

  end

end
